#!/usr/bin/env python3
"""Benchmark with memory profiling: compares Zig vs Scala on conference dataset."""

import sys, os, json, tempfile, time
from os.path import join, dirname, isfile
from subprocess import check_output, run, DEVNULL, PIPE
from shutil import rmtree
from collections import defaultdict

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure

UNION_INTERSECT_OVERLAP_THRESH = 0.8
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
SCALA_JAR = join(dirname(__file__), "..", "..", "pdffigures2", "pdffigures2.jar")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "pdfs")

def load_annotations():
    with open(ANNOTATIONS_FILE) as f:
        raw = json.load(f)
    annotations = {}
    for doc_id, doc_data in raw.items():
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        if not isfile(pdf_path):
            continue
        figs = []
        for f in doc_data["figures"]:
            figs.append(Figure(
                figure_type=str_to_fig_type(f["figure_type"]),
                name=f["name"], page=f["page"], dpi=f["dpi"],
                caption=f["caption"],
                page_height=f.get("page_height"), page_width=f.get("page_width"),
                caption_bb=f["caption_bb"], region_bb=f.get("region_bb"),
            ))
        annotations[doc_id] = {"figures": figs, "pages_annotated": doc_data["pages_annotated"], "pdf_path": pdf_path}
    return annotations

def run_zig_with_memory(pdf_path):
    result = run(["/usr/bin/time", "-v", ZIG_BINARY, pdf_path], capture_output=True, text=True)
    stderr = result.stderr
    mem_kb = 0
    for line in stderr.split("\n"):
        if "Maximum resident set size" in line:
            mem_kb = int(line.split(":")[-1].strip())
    figs = []
    for fig in json.loads(result.stdout).get("figures", []):
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
            caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                       fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
            region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                      fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
        ))
    for fig in json.loads(result.stdout).get("regionless-captions", []):
        bb = fig["boundary"]
        figs.append(Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("text", ""),
            caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None,
        ))
    return figs, mem_kb

def run_scala_with_memory(pdf_path):
    tmpdir = tempfile.mkdtemp()
    try:
        prefix = tmpdir + "/"
        result = run(["/usr/bin/time", "-v", "java", "-Djava.awt.headless=true", "-jar", SCALA_JAR,
                       "-d", prefix, "-c", "-e", "-q", pdf_path], capture_output=True, text=True)
        stderr = result.stderr
        mem_kb = 0
        for line in stderr.split("\n"):
            if "Maximum resident set size" in line:
                mem_kb = int(line.split(":")[-1].strip())
        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        json_path = join(prefix, doc_id + ".json")
        if not isfile(json_path):
            return [], mem_kb
        with open(json_path) as f:
            loaded = json.load(f)
        figs = []
        for fig in loaded["figures"] + loaded.get("regionless-captions", []):
            if "regionBoundary" in fig:
                figs.append(Figure(
                    figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                    page=fig["page"] + 1, dpi=72.0, caption=fig["caption"],
                    caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                               fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
                    region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                              fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
                ))
            else:
                bb = fig["boundary"]
                figs.append(Figure(
                    figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                    page=fig["page"] + 1, dpi=72.0, caption=fig["text"],
                    caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None,
                ))
        return figs, mem_kb
    finally:
        rmtree(tmpdir)

def pair_extractions(labels, extractions):
    label_ids = {fig.get_id(): fig for fig in labels}
    ids_in_extractions = set(fig.get_id() for fig in extractions)
    for fig_id, fig in label_ids.items():
        if fig_id not in ids_in_extractions:
            yield fig, None
    for fig in extractions:
        yield label_ids.get(fig.get_id()), fig

def grade_extractions(annotations, extractions):
    true_figs = annotations["figures"]
    ext_figs = [ex for ex in extractions if ex.page in annotations["pages_annotated"]]
    evaluated = []
    for true_fig, ext_fig in pair_extractions(true_figs, ext_figs):
        if ext_fig is None:
            error = Error.missing
        elif true_fig is None:
            error = Error.false_positive_no_region if ext_fig.region_bb is None else Error.false_positive
        else:
            cap_correct = box_overlap(ext_fig.caption_bb, true_fig.caption_bb)[0] >= UNION_INTERSECT_OVERLAP_THRESH
            if ext_fig.region_bb is None:
                error = Error.right_caption_no_region if cap_correct else Error.wrong_caption_no_region
            else:
                reg_correct = box_overlap(ext_fig.region_bb, true_fig.region_bb)[0] >= UNION_INTERSECT_OVERLAP_THRESH
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
    scored = [e for e in evaluated if e.error not in (Error.false_positive_no_region, Error.right_caption_no_region, Error.wrong_caption_no_region)]
    tp = sum(1 for e in scored if e.error == Error.correct)
    fp = sum(1 for e in scored if e.error == Error.false_positive)
    fn = sum(1 for e in scored if e.error == Error.missing)
    precision = tp / (tp + fp) if (tp + fp) > 0 else 0.0
    recall = tp / (tp + fn) if (tp + fn) > 0 else 0.0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0.0
    return {"precision": precision, "recall": recall, "f1": f1, "tp": tp, "fp": fp, "fn": fn}

def human_size(kb):
    if kb >= 1024*1024:
        return f"{kb/1024/1024:.1f} GB"
    elif kb >= 1024:
        return f"{kb/1024:.0f} MB"
    else:
        return f"{kb} KB"

def main():
    annotations = load_annotations()
    doc_ids = sorted(annotations.keys())
    print(f"{'='*70}")
    print(f"{'BENCHMARK: Zig vs Scala (with memory profiling)':^70}")
    print(f"{'='*70}")
    print(f"\nDocuments: {len(doc_ids)}")

    zig_mem = {}
    scala_mem = {}
    zig_times = {}
    scala_times = {}
    zig_errors_all = {}
    scala_errors_all = {}

    for i, doc_id in enumerate(doc_ids):
        pdf_path = annotations[doc_id]["pdf_path"]
        print(f"\n[{i+1}/{len(doc_ids)}] {doc_id}")

        # Zig
        t0 = time.time()
        try:
            zig_figs, zig_mem_kb = run_zig_with_memory(pdf_path)
        except Exception as e:
            print(f"  ZIG ERROR: {e}")
            zig_figs, zig_mem_kb = [], 0
        zig_times[doc_id] = time.time() - t0
        zig_mem[doc_id] = zig_mem_kb
        zig_errors_all[doc_id] = grade_extractions(annotations[doc_id], zig_figs)

        # Scala
        t0 = time.time()
        try:
            scala_figs, scala_mem_kb = run_scala_with_memory(pdf_path)
        except Exception as e:
            print(f"  SCALA ERROR: {e}")
            scala_figs, scala_mem_kb = [], 0
        scala_times[doc_id] = time.time() - t0
        scala_mem[doc_id] = scala_mem_kb
        scala_errors_all[doc_id] = grade_extractions(annotations[doc_id], scala_figs)

        z_c = sum(1 for e in zig_errors_all[doc_id] if e.error == Error.correct)
        s_c = sum(1 for e in scala_errors_all[doc_id] if e.error == Error.correct)
        total = len(annotations[doc_id]["figures"])
        z_m = human_size(zig_mem_kb)
        s_m = human_size(scala_mem_kb)
        print(f"  Truth: {total} | Zig: {z_c} TP, {zig_times[doc_id]:.2f}s, {z_m} | Scala: {s_c} TP, {scala_times[doc_id]:.2f}s, {s_m}")

    # Aggregate
    all_zig = [e for errs in zig_errors_all.values() for e in errs]
    all_scala = [e for errs in scala_errors_all.values() for e in errs]
    zm = compute_metrics(all_zig)
    sm = compute_metrics(all_scala)

    # Memory stats
    zig_mems = list(zig_mem.values())
    scala_mems = list(scala_mem.values())
    zig_mems.sort()
    scala_mems.sort()

    print(f"\n{'='*70}")
    print(f"{'RESULTS':^70}")
    print(f"{'='*70}")

    print(f"\n{'':>25} {'Zig (MuPDF)':>20} {'Scala (PDFBox)':>20}")
    print(f"  {'-'*65}")
    print(f"  {'Precision':25s} {zm['precision']:19.1%}  {sm['precision']:19.1%}")
    print(f"  {'Recall':25s} {zm['recall']:19.1%}  {sm['recall']:19.1%}")
    print(f"  {'F1 Score':25s} {zm['f1']:19.1%}  {sm['f1']:19.1%}")
    print(f"  {'True Positives':25s} {zm['tp']:19d}  {sm['tp']:19d}")
    print(f"  {'False Positives':25s} {zm['fp']:19d}  {sm['fp']:19d}")
    print(f"  {'False Negatives':25s} {zm['fn']:19d}  {sm['fn']:19d}")

    total_zig_time = sum(zig_times.values())
    total_scala_time = sum(scala_times.values())
    print(f"  {'Total Wall Time':25s} {total_zig_time:18.1f}s  {total_scala_time:18.1f}s")
    print(f"  {'Speedup':25s} {'—':>20}  {f'{total_scala_time/total_zig_time:.1f}x':>20}")

    print(f"\n{'Memory (Max RSS)':—^65}")
    print(f"  {'Peak (single PDF)':25s} {human_size(max(zig_mems)):>20}  {human_size(max(scala_mems)):>20}")
    print(f"  {'Median (per PDF)':25s} {human_size(zig_mems[len(zig_mems)//2]):>20}  {human_size(scala_mems[len(scala_mems)//2]):>20}")
    print(f"  {'Min (per PDF)':25s} {human_size(min(zig_mems)):>20}  {human_size(min(scala_mems)):>20}")
    print(f"  {'Sum (all PDFs)':25s} {human_size(sum(zig_mems)):>20}  {human_size(sum(scala_mems)):>20}")

    # Error breakdown
    from collections import Counter
    for label, evals in [("Zig", all_zig), ("Scala", all_scala)]:
        c = Counter(e.error for e in evals)
        print(f"\n  {label} errors:")
        for err, count in sorted(c.items(), key=lambda x: -x[1]):
            print(f"    {err.name:30s}: {count:3d}")


if __name__ == "__main__":
    main()