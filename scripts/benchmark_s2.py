#!/usr/bin/env python3
"""
Benchmark script for the S2 dataset: compares pdffigures2-zig vs pdffigures2-scala
against the S2 annotations.

Usage: python3 benchmark_s2.py [--zig-only] [--scala-only]
"""

import sys, os, json, tempfile, time
from os.path import join, dirname, isfile
from subprocess import check_output, call, DEVNULL
from shutil import rmtree

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure, scale_figure

UNION_INTERSECT_OVERLAP_THRESH = 0.8

ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
SCALA_JAR = join(dirname(__file__), "..", "..", "pdffigures2", "pdffigures2.jar")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
                         "datasets", "s2", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
               "datasets", "s2", "pdfs")
PAGES_ANNOTATED_FILE = join(dirname(__file__), "..", "pdffigures2", "evaluation",
                            "datasets", "s2", "pages_annotated.json")


def load_annotations():
    with open(ANNOTATIONS_FILE) as f:
        raw = json.load(f)
    if isfile(PAGES_ANNOTATED_FILE):
        with open(PAGES_ANNOTATED_FILE) as f:
            pages_annotated = json.load(f)
    else:
        pages_annotated = {}

    annotations = {}
    for doc_id, doc_data in raw.items():
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        if not isfile(pdf_path):
            continue
        figs = []
        for f in doc_data["figures"]:
            fig = Figure(
                figure_type=str_to_fig_type(f["figure_type"]),
                name=f["name"],
                page=f["page"],
                dpi=f["dpi"],
                caption=f["caption"],
                page_height=f.get("page_height"),
                page_width=f.get("page_width"),
                caption_bb=f["caption_bb"],
                region_bb=f.get("region_bb"),
            )
            caption_bb, region_bb = scale_figure(fig, 72.0)
            fig.caption_bb = caption_bb
            fig.region_bb = region_bb
            fig.dpi = 72.0
            figs.append(fig)
        annotated_pages = pages_annotated.get(doc_id, doc_data.get("pages_annotated", []))
        annotations[doc_id] = {
            "figures": figs,
            "pages_annotated": annotated_pages,
            "pdf_path": pdf_path,
        }
    return annotations


def run_zig(pdf_path):
    output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
    loaded = json.loads(output)
    figs = []
    for fig in loaded.get("figures", []):
        caption_bb = [
            fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
            fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"],
        ]
        region_bb = [
            fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
            fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"],
        ]
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]),
            name=fig["name"],
            page=fig["page"] + 1,
            dpi=72.0,
            caption=fig.get("caption", ""),
            caption_bb=caption_bb,
            region_bb=region_bb,
        ))
    for fig in loaded.get("regionless-captions", []):
        bb = fig["boundary"]
        caption_bb = [bb["x1"], bb["y1"], bb["x2"], bb["y2"]]
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]),
            name=fig["name"],
            page=fig["page"] + 1,
            dpi=72.0,
            caption=fig.get("text", ""),
            caption_bb=caption_bb,
            region_bb=None,
        ))
    return figs


def run_scala(pdf_path):
    tmpdir = tempfile.mkdtemp()
    try:
        prefix = tmpdir + "/"
        args = ["java", "-Djava.awt.headless=true", "-jar", SCALA_JAR,
                "-d", prefix, "-c", "-e", "-q", pdf_path]
        ret = call(args, stdout=DEVNULL, stderr=DEVNULL)
        if ret != 0:
            raise RuntimeError(f"Scala JAR returned {ret}")
        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        json_path = prefix + doc_id + ".json"
        if not isfile(json_path):
            return []
        with open(json_path) as f:
            loaded = json.load(f)
        figs = []
        for fig in loaded["figures"] + loaded.get("regionless-captions", []):
            if "regionBoundary" in fig:
                caption_bb = [
                    fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                    fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"],
                ]
                region_bb = [
                    fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                    fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"],
                ]
                caption = fig["caption"]
            else:
                bb = fig["boundary"]
                caption_bb = [bb["x1"], bb["y1"], bb["x2"], bb["y2"]]
                caption = fig["text"]
                region_bb = None
            figs.append(Figure(
                figure_type=str_to_fig_type(fig["figType"]),
                name=fig["name"],
                page=fig["page"] + 1,
                dpi=72.0,
                caption=caption,
                caption_bb=caption_bb,
                region_bb=region_bb,
            ))
        return figs
    finally:
        rmtree(tmpdir)


def pair_extractions(labels, extractions):
    label_ids = {fig.get_id(): fig for fig in labels}
    if len(label_ids) != len(labels):
        raise ValueError("Duplicate labels")
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
                if cap_correct:
                    error = Error.right_caption_no_region
                else:
                    error = Error.wrong_caption_no_region
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


def compute_metrics(evaluated):
    tp = sum(1 for e in evaluated if e.error == Error.correct)
    fp = sum(1 for e in evaluated if e.error in (Error.false_positive, Error.false_positive_no_region))
    fn = sum(1 for e in evaluated if e.error == Error.missing)

    scored = [
        e for e in evaluated
        if e.error not in (Error.false_positive_no_region, Error.right_caption_no_region,
                          Error.wrong_caption_no_region)
    ]
    tp_scored = sum(1 for e in scored if e.error == Error.correct)
    fp_scored = sum(1 for e in scored if e.error in (Error.false_positive,))
    fn_scored = sum(1 for e in scored if e.error == Error.missing)

    precision = tp_scored / (tp_scored + fp_scored) if (tp_scored + fp_scored) > 0 else 0.0
    recall = tp_scored / (tp_scored + fn_scored) if (tp_scored + fn_scored) > 0 else 0.0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0.0

    return {
        "precision": precision,
        "recall": recall,
        "f1": f1,
        "tp": tp_scored,
        "fp": fp_scored,
        "fn": fn_scored,
        "total_scored": len(scored),
        "total_annotations": len([e for e in evaluated if e.true_figure is not None]),
        "total_extractions": len([e for e in evaluated if e.extracted_figure is not None]),
    }


def print_error_breakdown(evaluated, label):
    from collections import Counter
    c = Counter(e.error for e in evaluated)
    print(f"\n  {label} error breakdown:")
    for err, count in sorted(c.items(), key=lambda x: -x[1]):
        print(f"    {err.name:30s}: {count:3d}")


def main():
    zig_only = "--zig-only" in sys.argv
    scala_only = "--scala-only" in sys.argv

    print("Loading S2 annotations...")
    annotations = load_annotations()
    doc_ids = sorted(annotations.keys())
    print(f"Found {len(doc_ids)} annotated PDFs with downloaded files\n")

    zig_errors = {}
    scala_errors = {}
    zig_times = {}
    scala_times = {}

    for i, doc_id in enumerate(doc_ids):
        pdf_path = annotations[doc_id]["pdf_path"]
        print(f"[{i+1}/{len(doc_ids)}] {doc_id}")

        if not scala_only:
            t0 = time.time()
            try:
                zig_figs = run_zig(pdf_path)
            except Exception as e:
                print(f"  ZIG ERROR: {e}")
                zig_figs = []
            zig_times[doc_id] = time.time() - t0
            zig_errors[doc_id] = grade_extractions(annotations[doc_id], zig_figs)

        if not zig_only:
            t0 = time.time()
            try:
                scala_figs = run_scala(pdf_path)
            except Exception as e:
                print(f"  SCALA ERROR: {e}")
                scala_figs = []
            scala_times[doc_id] = time.time() - t0
            scala_errors[doc_id] = grade_extractions(annotations[doc_id], scala_figs)

        n_true = len(annotations[doc_id]["figures"])
        z_c = sum(1 for e in zig_errors.get(doc_id, []) if e.error == Error.correct) if not scala_only else 0
        s_c = sum(1 for e in scala_errors.get(doc_id, []) if e.error == Error.correct) if not zig_only else 0
        if not scala_only and not zig_only:
            print(f"  Truth: {n_true} figs | Zig correct: {z_c} | Scala correct: {s_c}")
        elif not scala_only:
            print(f"  Truth: {n_true} figs | Zig correct: {z_c}")
        else:
            print(f"  Truth: {n_true} figs | Scala correct: {s_c}")

    # Aggregate results
    if not scala_only:
        all_zig = [e for errs in zig_errors.values() for e in errs]
        zig_metrics = compute_metrics(all_zig)
    if not zig_only:
        all_scala = [e for errs in scala_errors.values() for e in errs]
        scala_metrics = compute_metrics(all_scala)

    total_zig_time = sum(zig_times.values()) if zig_times else 0
    total_scala_time = sum(scala_times.values()) if scala_times else 0

    print("\n" + "=" * 70)
    print("S2 BENCHMARK RESULTS")
    print("=" * 70)

    if not scala_only and not zig_only:
        print(f"\n{'':>20} {'Zig (MuPDF)':>15} {'Scala (PDFBox)':>15}")
        print(f"  {'-' * 48}")
        print(f"  {'Precision':20s} {zig_metrics['precision']:14.1%}  {scala_metrics['precision']:14.1%}")
        print(f"  {'Recall':20s} {zig_metrics['recall']:14.1%}  {scala_metrics['recall']:14.1%}")
        print(f"  {'F1 Score':20s} {zig_metrics['f1']:14.1%}  {scala_metrics['f1']:14.1%}")
        print(f"  {'True Positives':20s} {zig_metrics['tp']:14d}  {scala_metrics['tp']:14d}")
        print(f"  {'False Positives':20s} {zig_metrics['fp']:14d}  {scala_metrics['fp']:14d}")
        print(f"  {'False Negatives':20s} {zig_metrics['fn']:14d}  {scala_metrics['fn']:14d}")
        print(f"  {'Total Scored':20s} {zig_metrics['total_scored']:14d}  {scala_metrics['total_scored']:14d}")
        print(f"  {'Total Time':20s} {total_zig_time:13.1f}s  {total_scala_time:13.1f}s")
    elif not scala_only:
        print(f"\n{'':>20} {'Zig (MuPDF)':>15}")
        print(f"  {'-' * 35}")
        print(f"  {'Precision':20s} {zig_metrics['precision']:14.1%}")
        print(f"  {'Recall':20s} {zig_metrics['recall']:14.1%}")
        print(f"  {'F1 Score':20s} {zig_metrics['f1']:14.1%}")
        print(f"  {'True Positives':20s} {zig_metrics['tp']:14d}")
        print(f"  {'False Positives':20s} {zig_metrics['fp']:14d}")
        print(f"  {'False Negatives':20s} {zig_metrics['fn']:14d}")
        print(f"  {'Total Scored':20s} {zig_metrics['total_scored']:14d}")
        print(f"  {'Total Time':20s} {total_zig_time:13.1f}s")
    elif not zig_only:
        print(f"\n{'':>20} {'Scala (PDFBox)':>15}")
        print(f"  {'-' * 35}")
        print(f"  {'Precision':20s} {scala_metrics['precision']:14.1%}")
        print(f"  {'Recall':20s} {scala_metrics['recall']:14.1%}")
        print(f"  {'F1 Score':20s} {scala_metrics['f1']:14.1%}")
        print(f"  {'True Positives':20s} {scala_metrics['tp']:14d}")
        print(f"  {'False Positives':20s} {scala_metrics['fp']:14d}")
        print(f"  {'False Negatives':20s} {scala_metrics['fn']:14d}")

    if not scala_only:
        print_error_breakdown(all_zig, "Zig")
    if not zig_only:
        print_error_breakdown(all_scala, "Scala")

    if not scala_only and not zig_only:
        sep = "=" * 70
        print(f"\n{sep}")
        print("PER-DOCUMENT COMPARISON (correct / total)")
        print("=" * 70)
        diffs = []
        for doc_id in doc_ids:
            z_c = sum(1 for e in zig_errors[doc_id] if e.error == Error.correct)
            s_c = sum(1 for e in scala_errors[doc_id] if e.error == Error.correct)
            total = len(annotations[doc_id]["figures"])
            if z_c != s_c:
                diffs.append((doc_id, z_c, s_c, total))
                marker = " ***"
            else:
                marker = ""
            print(f"  {doc_id:20s}  Zig: {z_c:2d}/{total:<2d}  Scala: {s_c:2d}/{total:<2d}{marker}")

        if diffs:
            print(f"\n{diffs.__len__()} documents have different scores:")
            for doc_id, zc, sc, total in diffs:
                print(f"  {doc_id}: Zig={zc}/{total}, Scala={sc}/{total}")
        else:
            print(f"\nAll {len(doc_ids)} documents have identical scores.")

    if not scala_only and not zig_only and total_scala_time > 0:
        print(f"\nSpeed: Zig is {total_scala_time/total_zig_time:.2f}x vs Scala JAR (wall time)")


if __name__ == "__main__":
    main()