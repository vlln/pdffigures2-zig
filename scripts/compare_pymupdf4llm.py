#!/usr/bin/env python3
"""Compare figure extraction: pdffigures2-zig vs pymupdf4llm on conference dataset.

Evaluates both tools against ground truth annotations and against each other.
"""

import sys, os, json
from os.path import join, dirname, isfile
from subprocess import run, DEVNULL
from collections import defaultdict

ZIG_BIN = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "pdfs")
ANNOTATIONS = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "annotations.json")

MIN_AREA = 5000  # filter fragments: ~0.3in x 0.3in at 72dpi


def load_annotations():
    with open(ANNOTATIONS) as f:
        raw = json.load(f)
    result = {}
    for doc_id, doc_data in raw.items():
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        if not isfile(pdf_path):
            continue
        figs = []
        for f in doc_data["figures"]:
            figs.append({
                "name": f["name"], "type": f["figure_type"],
                "page": f["page"] - 1,  # 1-indexed -> 0-indexed
                "caption_bb": f["caption_bb"],
                "region_bb": f.get("region_bb"),
            })
        result[doc_id] = {"figures": figs, "pages_annotated": doc_data["pages_annotated"],
                          "pdf_path": pdf_path}
    return result


def run_pdffigures2(pdf_path):
    result = run([ZIG_BIN, pdf_path], capture_output=True, text=True)
    data = json.loads(result.stdout)
    figures = []
    for fig in data.get("figures", []):
        figures.append({
            "name": fig["name"], "type": fig["figType"],
            "page": fig["page"],
            "caption_bb": [fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                          fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
            "region_bb": [fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                         fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
        })
    for fig in data.get("regionless-captions", []):
        bb = fig["boundary"]
        figures.append({
            "name": fig["name"], "type": fig["figType"],
            "page": fig["page"],
            "caption_bb": [bb["x1"], bb["y1"], bb["x2"], bb["y2"]],
            "region_bb": None,
        })
    return figures


def extract_pymupdf4llm(pdf_path):
    from pymupdf4llm.helpers.document_layout import parse_document
    doc = parse_document(pdf_path)
    pictures = []
    tables = []
    captions = []
    tiny = 0
    for page in doc.pages:
        for box in page.boxes:
            bbox = [box.x0, box.y0, box.x1, box.y1]
            area = (box.x1 - box.x0) * (box.y1 - box.y0)
            if box.boxclass == "picture":
                if area < MIN_AREA:
                    tiny += 1
                    continue
                pictures.append({"page": page.page_number - 1, "bbox": bbox})
            elif box.boxclass == "table":
                if area < MIN_AREA:
                    tiny += 1
                    continue
                rows = box.table.get("row_count", 0) if box.table else 0
                cols = box.table.get("col_count", 0) if box.table else 0
                tables.append({"page": page.page_number - 1, "bbox": bbox,
                               "rows": rows, "cols": cols})
            elif box.boxclass == "caption":
                captions.append({"page": page.page_number - 1, "bbox": bbox})
    return pictures, tables, captions, tiny


def box_iou(a, b):
    if a is None or b is None:
        return 0.0
    x1 = max(a[0], b[0])
    y1 = max(a[1], b[1])
    x2 = min(a[2], b[2])
    y2 = min(a[3], b[3])
    if x2 <= x1 or y2 <= y1:
        return 0.0
    inter = (x2 - x1) * (y2 - y1)
    area_a = max(0, a[2] - a[0]) * max(0, a[3] - a[1])
    area_b = max(0, b[2] - b[0]) * max(0, b[3] - b[1])
    union = area_a + area_b - inter
    return inter / union if union > 0 else 0.0


def best_iou(target_bb, candidates, key="bbox"):
    best, best_idx = 0.0, -1
    for i, cand in enumerate(candidates):
        iou = box_iou(target_bb, cand[key])
        if iou > best:
            best, best_idx = iou, i
    return best, best_idx


def match_to_ground_truth(detections, gt_figures, det_key="caption_bb", gt_key="caption_bb", iou_thresh=0.8):
    """Count how many GT figures are matched by detections (IoU)."""
    matched = 0
    for gt in gt_figures:
        if gt[gt_key] is None:
            continue
        iou, _ = best_iou(gt[gt_key], detections, key=det_key)
        if iou >= iou_thresh:
            matched += 1
    return matched


def run_comparison():
    annotations = load_annotations()
    doc_ids = sorted(annotations.keys())
    print(f"Comparing pdffigures2-zig vs pymupdf4llm on {len(doc_ids)} PDFs")
    print(f"(pymupdf4llm picture/table blocks with area < {MIN_AREA} px^2 filtered as fragments)\n")

    # Aggregate counters
    total_gt = 0
    total_zig = 0
    total_zig_regionless = 0
    total_llm_pics = 0
    total_llm_tables = 0
    total_llm_captions = 0
    total_llm_tiny = 0

    gt_matched_zig = 0
    gt_matched_llm = 0

    # Cross-tool matching
    zig_matched_by_llm = 0  # zig regions matched by >=1 llm block
    llm_matched_by_zig = 0  # llm blocks matched by >=1 zig region

    # Per-doc detail
    rows = []

    for i, doc_id in enumerate(doc_ids):
        pdf_path = annotations[doc_id]["pdf_path"]
        gt_figs = annotations[doc_id]["figures"]
        gt_on_annotated = [f for f in gt_figs
                          if f["page"] + 1 in annotations[doc_id]["pages_annotated"]]

        zig_figs = run_pdffigures2(pdf_path)
        llm_pics, llm_tables, llm_captions, llm_tiny = extract_pymupdf4llm(pdf_path)

        n_gt = len(gt_on_annotated)
        n_zig_regions = sum(1 for f in zig_figs if f["region_bb"] is not None)
        n_zig_regionless = sum(1 for f in zig_figs if f["region_bb"] is None)
        llm_figs = llm_pics + llm_tables
        n_llm_figs = len(llm_figs)

        # Ground truth matching (caption_bb for zig, region_bb for llm blocks)
        zig_gt = match_to_ground_truth(zig_figs, gt_on_annotated)
        llm_gt = match_to_ground_truth(llm_figs, gt_on_annotated, det_key="bbox", gt_key="region_bb")

        # Cross-tool matching
        zig_regions = [f for f in zig_figs if f["region_bb"] is not None]

        zig_matched = 0
        for fig in zig_regions:
            iou, _ = best_iou(fig["region_bb"], llm_figs)
            if iou >= 0.5:
                zig_matched += 1

        llm_matched = 0
        zig_region_boxes = [{"bbox": f["region_bb"]} for f in zig_regions]
        for fig in llm_figs:
            iou, _ = best_iou(fig["bbox"], zig_region_boxes)
            if iou >= 0.5:
                llm_matched += 1

        total_gt += n_gt
        total_zig += n_zig_regions + n_zig_regionless
        total_zig_regionless += n_zig_regionless
        total_llm_pics += len(llm_pics)
        total_llm_tables += len(llm_tables)
        total_llm_captions += len(llm_captions)
        total_llm_tiny += llm_tiny
        gt_matched_zig += zig_gt
        gt_matched_llm += llm_gt
        zig_matched_by_llm += zig_matched
        llm_matched_by_zig += llm_matched

        rows.append((doc_id, n_gt, n_zig_regions, n_zig_regionless, len(llm_pics), len(llm_tables),
                     zig_gt, llm_gt, zig_matched, n_zig_regions, llm_matched, n_llm_figs, llm_tiny))

        print(f"[{i+1:2d}/{len(doc_ids)}] {doc_id:12s}  "
              f"GT:{n_gt:2d}  "
              f"Zig:{n_zig_regions:2d}+{n_zig_regionless}r  "
              f"LLM:{len(llm_pics):2d}p+{len(llm_tables)}t  "
              f"GT→Zig:{zig_gt}/{n_gt}  GT→LLM:{llm_gt}/{n_gt}  "
              f"Zig↔LLM:{zig_matched}/{n_zig_regions}  LLM↔Zig:{llm_matched}/{n_llm_figs}"
              + (f"  tiny:{llm_tiny}" if llm_tiny > 0 else ""))

    total_zig_regions = total_zig - total_zig_regionless
    total_llm_figs = total_llm_pics + total_llm_tables

    print(f"\n{'='*70}")
    print(f"SUMMARY")
    print(f"{'='*70}")
    print(f"  Ground truth figures:              {total_gt}")
    print(f"")
    print(f"  pdffigures2-zig:                   {total_zig} total ({total_zig_regions} with region, {total_zig_regionless} regionless)")
    print(f"  pymupdf4llm:                       {total_llm_pics} pictures + {total_llm_tables} tables = {total_llm_figs} total")
    print(f"    (filtered {total_llm_tiny} tiny picture/table fragments < {MIN_AREA} px^2)")
    print(f"  pymupdf4llm captions:              {total_llm_captions}")
    print(f"")
    print(f"  Ground truth recall (caption IoU >= 0.8):")
    zig_recall = gt_matched_zig / max(1, total_gt) * 100
    llm_recall = gt_matched_llm / max(1, total_gt) * 100
    print(f"    pdffigures2-zig:                 {gt_matched_zig}/{total_gt} ({zig_recall:.1f}%)")
    print(f"    pymupdf4llm:                     {gt_matched_llm}/{total_gt} ({llm_recall:.1f}%)")
    print(f"")
    print(f"  Cross-tool agreement (region IoU >= 0.5):")
    print(f"    Zig figures matched by LLM:      {zig_matched_by_llm}/{total_zig_regions} ({zig_matched_by_llm/max(1,total_zig_regions)*100:.1f}%)")
    print(f"    LLM figures matched by Zig:      {llm_matched_by_zig}/{total_llm_figs} ({llm_matched_by_zig/max(1,total_llm_figs)*100:.1f}%)")

    # Documents with largest discrepancies
    print(f"\n{'='*70}")
    print(f"BIGGEST DISCREPANCIES (by unmatched figures)")
    print(f"{'='*70}")
    discrepancies = []
    for row in rows:
        doc_id, n_gt, nzr, nzrl, nlp, nlt, zg, lg, zm, nzr2, lm, nlf, tiny = row
        zig_only = nzr - zm  # zig figures not matched by llm
        llm_only = nlf - lm  # llm figures not matched by zig
        discrepancies.append((zig_only + llm_only, doc_id, zig_only, llm_only, nzr, nlf, tiny))
    discrepancies.sort(reverse=True)
    for score, doc_id, zo, lo, nzr, nlf, tiny in discrepancies[:10]:
        parts = [f"Zig:{nzr} LLM:{nlf}"]
        if zo: parts.append(f"Zig-only:{zo}")
        if lo: parts.append(f"LLM-only:{lo}")
        if tiny: parts.append(f"tiny:{tiny}")
        print(f"  {doc_id:12s}  {'  '.join(parts)}")


if __name__ == "__main__":
    run_comparison()