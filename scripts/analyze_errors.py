#!/usr/bin/env python3
"""Analyze all error cases across S2 dataset to find systematic patterns."""
import sys, os, json
from os.path import join, dirname, isfile
from subprocess import check_output, DEVNULL
from collections import Counter, defaultdict

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure, scale_figure

UNION_INTERSECT_OVERLAP_THRESH = 0.8
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
                       "datasets", "s2", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
               "datasets", "s2", "pdfs")
PAGES_ANNOTATED_FILE = join(dirname(__file__), "..", "pdffigures2", "evaluation",
                            "datasets", "s2", "pages_annotated.json")

with open(ANNOTATIONS_FILE) as f:
    raw = json.load(f)
if isfile(PAGES_ANNOTATED_FILE):
    with open(PAGES_ANNOTATED_FILE) as f:
        pages_annotated = json.load(f)
else:
    pages_annotated = {}

def load_annotations():
    annotations = {}
    for doc_id, doc_data in raw.items():
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        if not isfile(pdf_path):
            continue
        figs = []
        for f in doc_data["figures"]:
            fig = Figure(
                figure_type=str_to_fig_type(f["figure_type"]),
                name=f["name"], page=f["page"], dpi=f["dpi"],
                caption=f["caption"], page_height=f.get("page_height"),
                page_width=f.get("page_width"),
                caption_bb=f["caption_bb"], region_bb=f.get("region_bb"),
            )
            caption_bb, region_bb = scale_figure(fig, 72.0)
            fig.caption_bb = caption_bb
            fig.region_bb = region_bb
            fig.dpi = 72.0
            figs.append(fig)
        annotated_pages = pages_annotated.get(doc_id, doc_data.get("pages_annotated", []))
        annotations[doc_id] = {"figures": figs, "pages_annotated": annotated_pages, "pdf_path": pdf_path}
    return annotations

def run_zig(pdf_path):
    output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
    loaded = json.loads(output)
    figs = []
    for fig in loaded.get("figures", []):
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
            caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                        fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
            region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                       fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
        ))
    for fig in loaded.get("regionless-captions", []):
        bb = fig["boundary"]
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("text", ""),
            caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None,
        ))
    return figs

def pair_extractions(labels, extractions):
    label_ids = {fig.get_id(): fig for fig in labels}
    ids_in_extractions = set(fig.get_id() for fig in extractions)
    for fig_id, fig in label_ids.items():
        if fig_id not in ids_in_extractions:
            yield fig, None
    for fig in extractions:
        fig_id = fig.get_id()
        yield label_ids.get(fig_id), fig

def grade_extractions(annotations, extractions):
    true_figs = annotations["figures"]
    ext_figs = [ex for ex in extractions if ex.page in annotations["pages_annotated"]]
    evaluated = []
    for true_fig, ext_fig in pair_extractions(true_figs, ext_figs):
        if ext_fig is None:
            error = Error.missing
        elif ext_fig.caption_bb is None:
            error = Error.wrong_caption_no_region
        elif true_fig is None:
            if ext_fig.region_bb is None:
                error = Error.false_positive_no_region
            else:
                error = Error.false_positive
        else:
            true_cap = true_fig.caption_bb
            true_reg = true_fig.region_bb
            ext_cap = ext_fig.caption_bb
            ext_reg = ext_fig.region_bb
            cap_correct = box_overlap(ext_cap, true_cap)[0] >= UNION_INTERSECT_OVERLAP_THRESH
            if ext_reg is None:
                error = Error.right_caption_no_region if cap_correct else Error.wrong_caption_no_region
            else:
                reg_correct = box_overlap(ext_reg, true_reg)[0] >= UNION_INTERSECT_OVERLAP_THRESH
                if not reg_correct and not cap_correct:
                    error = Error.wrong_caption_and_region
                elif not reg_correct:
                    error = Error.wrong_region_box
                elif not cap_correct:
                    error = Error.wrong_caption_box
                else:
                    error = Error.correct
        evaluated.append(EvaluatedFigure(true_fig, ext_fig, error, ""))
    return evaluated

annotations = load_annotations()
doc_ids = sorted(annotations.keys())

# Collect detailed error information
wcar_cases = []
wrb_cases = []
wcb_cases = []
missing_cases = []

for doc_id in doc_ids:
    ann = annotations[doc_id]
    pdf_path = ann["pdf_path"]
    zig_figs = run_zig(pdf_path)
    zig_eval = grade_extractions(ann, zig_figs)

    for ze in zig_eval:
        cap_iou = 0.0
        reg_iou = 0.0
        if ze.extracted_figure and ze.true_figure:
            if ze.extracted_figure.caption_bb and ze.true_figure.caption_bb:
                cap_iou = box_overlap(ze.extracted_figure.caption_bb, ze.true_figure.caption_bb)[0]
            if ze.extracted_figure.region_bb and ze.true_figure.region_bb:
                reg_iou = box_overlap(ze.extracted_figure.region_bb, ze.true_figure.region_bb)[0]

        if ze.error == Error.wrong_caption_and_region:
            wcar_cases.append((doc_id, ze, cap_iou, reg_iou))
        elif ze.error == Error.wrong_region_box:
            wrb_cases.append((doc_id, ze, cap_iou, reg_iou))
        elif ze.error == Error.wrong_caption_box:
            wcb_cases.append((doc_id, ze, cap_iou, reg_iou))
        elif ze.error == Error.missing:
            missing_cases.append((doc_id, ze))

print(f"=== ERROR ANALYSIS ===")
print(f"wrong_caption_and_region: {len(wcar_cases)}")
print(f"wrong_region_box: {len(wrb_cases)}")
print(f"wrong_caption_box: {len(wcb_cases)}")
print(f"missing: {len(missing_cases)}")

# Analyze wcar: caption IoU distribution
print(f"\n=== WRONG CAPTION AND REGION ({len(wcar_cases)} cases) ===")
cap_ious_wcar = [c[2] for c in wcar_cases]
reg_ious_wcar = [c[3] for c in wcar_cases]
print(f"Caption IoU distribution:")
buckets = [(0, 0.1), (0.1, 0.3), (0.3, 0.5), (0.5, 0.7), (0.7, 0.79), (0.79, 0.8)]
for lo, hi in buckets:
    count = sum(1 for i in cap_ious_wcar if lo <= i < hi)
    print(f"  [{lo:.1f}, {hi:.2f}): {count}")
print(f"Region IoU distribution:")
for lo, hi in [(0, 0.1), (0.1, 0.3), (0.3, 0.5), (0.5, 0.7), (0.7, 0.8)]:
    count = sum(1 for i in reg_ious_wcar if lo <= i < hi)
    print(f"  [{lo:.1f}, {hi:.1f}): {count}")

# Near-miss analysis: wcar cases where cap_iou is close to 0.8
near_miss_wcar = [(doc_id, ze, ci, ri) for doc_id, ze, ci, ri in wcar_cases if ci >= 0.7]
print(f"\nNear-miss wcar (cap_iou >= 0.7): {len(near_miss_wcar)} cases")
for doc_id, ze, ci, ri in near_miss_wcar:
    tc = ze.true_figure.caption_bb
    ec = ze.extracted_figure.caption_bb
    print(f"  {doc_id[:20]} {ze.true_figure.get_id()}: cap_iou={ci:.3f} reg_iou={ri:.3f}")
    print(f"    True cap: [{tc[0]:.0f},{tc[1]:.0f},{tc[2]:.0f},{tc[3]:.0f}] h={tc[3]-tc[1]:.0f}")
    print(f"    Zig cap:  [{ec[0]:.0f},{ec[1]:.0f},{ec[2]:.0f},{ec[3]:.0f}] h={ec[3]-ec[1]:.0f}")
    if ze.true_figure.region_bb and ze.extracted_figure.region_bb:
        tr = ze.true_figure.region_bb
        er = ze.extracted_figure.region_bb
        print(f"    True reg: [{tr[0]:.0f},{tr[1]:.0f},{tr[2]:.0f},{tr[3]:.0f}] h={tr[3]-tr[1]:.0f}")
        print(f"    Zig reg:  [{er[0]:.0f},{er[1]:.0f},{er[2]:.0f},{er[3]:.0f}] h={er[3]-er[1]:.0f}")

# Analyze wrong_region_box
print(f"\n=== WRONG REGION BOX ({len(wrb_cases)} cases) ===")
reg_ious_wrb = [c[3] for c in wrb_cases]
print(f"Region IoU distribution:")
for lo, hi in [(0, 0.1), (0.1, 0.3), (0.3, 0.5), (0.5, 0.7), (0.7, 0.8)]:
    count = sum(1 for i in reg_ious_wrb if lo <= i < hi)
    print(f"  [{lo:.1f}, {hi:.1f}): {count}")

# Near-miss wrb cases
near_miss_wrb = [(doc_id, ze, ci, ri) for doc_id, ze, ci, ri in wrb_cases if ri >= 0.5]
print(f"\nNear-miss wrb (reg_iou >= 0.5): {len(near_miss_wrb)} cases")
for doc_id, ze, ci, ri in near_miss_wrb[:10]:
    tr = ze.true_figure.region_bb
    er = ze.extracted_figure.region_bb
    print(f"  {doc_id[:20]} {ze.true_figure.get_id()}: reg_iou={ri:.3f}")
    print(f"    True reg: [{tr[0]:.0f},{tr[1]:.0f},{tr[2]:.0f},{tr[3]:.0f}]")
    print(f"    Zig reg:  [{er[0]:.0f},{er[1]:.0f},{er[2]:.0f},{er[3]:.0f}]")

# Analyze wrong_caption_box
print(f"\n=== WRONG CAPTION BOX ({len(wcb_cases)} cases) ===")
cap_ious_wcb = [c[2] for c in wcb_cases]
print(f"Caption IoU distribution:")
for lo, hi in [(0, 0.1), (0.1, 0.3), (0.3, 0.5), (0.5, 0.7), (0.7, 0.79), (0.79, 0.8)]:
    count = sum(1 for i in cap_ious_wcb if lo <= i < hi)
    print(f"  [{lo:.1f}, {hi:.2f}): {count}")

# Near-miss wcb cases
near_miss_wcb = [(doc_id, ze, ci, ri) for doc_id, ze, ci, ri in wcb_cases if ci >= 0.5]
print(f"\nNear-miss wcb (cap_iou >= 0.5): {len(near_miss_wcb)} cases")
for doc_id, ze, ci, ri in near_miss_wcb[:10]:
    tc = ze.true_figure.caption_bb
    ec = ze.extracted_figure.caption_bb
    print(f"  {doc_id[:20]} {ze.true_figure.get_id()}: cap_iou={ci:.3f}")
    print(f"    True cap: [{tc[0]:.0f},{tc[1]:.0f},{tc[2]:.0f},{tc[3]:.0f}] h={tc[3]-tc[1]:.0f}")
    print(f"    Zig cap:  [{ec[0]:.0f},{ec[1]:.0f},{ec[2]:.0f},{ec[3]:.0f}] h={ec[3]-ec[1]:.0f}")

# Analyze missing
print(f"\n=== MISSING ({len(missing_cases)} cases) ===")
missing_by_doc = defaultdict(list)
for doc_id, ze in missing_cases:
    missing_by_doc[doc_id].append(ze)
for doc_id, cases in sorted(missing_by_doc.items(), key=lambda x: -len(x[1])):
    print(f"  {doc_id}: {len(cases)} missing")
    for ze in cases[:3]:
        fid = ze.true_figure.get_id()
        print(f"    {fid}: caption='{ze.true_figure.caption[:80]}'")