#!/usr/bin/env python3
"""Show ALL cases where Scala detects correctly but Zig does not (any error type)."""
import sys, os, json, tempfile
from os.path import join, dirname, isfile
from subprocess import check_output, call, DEVNULL
from shutil import rmtree
from collections import Counter

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure

UNION_INTERSECT_OVERLAP_THRESH = 0.8
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
SCALA_JAR = join(dirname(__file__), "..", "..", "pdffigures2", "pdffigures2.jar")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
                         "datasets", "conference", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
               "datasets", "conference", "pdfs")

def load_annotations():
    with open(ANNOTATIONS_FILE) as f: raw = json.load(f)
    annotations = {}
    for doc_id, doc_data in raw.items():
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        if not isfile(pdf_path): continue
        figs = []
        for f in doc_data["figures"]:
            figs.append(Figure(figure_type=str_to_fig_type(f["figure_type"]), name=f["name"],
                              page=f["page"], dpi=f["dpi"], caption=f["caption"],
                              page_height=f.get("page_height"), page_width=f.get("page_width"),
                              caption_bb=f["caption_bb"], region_bb=f.get("region_bb")))
        annotations[doc_id] = {"figures": figs, "pages_annotated": doc_data["pages_annotated"], "pdf_path": pdf_path}
    return annotations

def run_zig(pdf_path):
    output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
    loaded = json.loads(output)
    figs = []
    for fig in loaded.get("figures", []):
        caption_bb = [fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                      fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]]
        region_bb = [fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                     fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]]
        figs.append(Figure(figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                          page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
                          caption_bb=caption_bb, region_bb=region_bb))
    for fig in loaded.get("regionless-captions", []):
        bb = fig["boundary"]
        figs.append(Figure(figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                          page=fig["page"] + 1, dpi=72.0, caption=fig.get("text", ""),
                          caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None))
    return figs

def run_scala(pdf_path):
    tmpdir = tempfile.mkdtemp()
    try:
        prefix = tmpdir + "/"
        args = ["java", "-Djava.awt.headless=true", "-jar", SCALA_JAR, "-d", prefix, "-c", "-e", "-q", pdf_path]
        if call(args, stdout=DEVNULL, stderr=DEVNULL) != 0: return []
        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        json_path = prefix + doc_id + ".json"
        if not isfile(json_path): return []
        with open(json_path) as f: loaded = json.load(f)
        figs = []
        for fig in loaded["figures"] + loaded.get("regionless-captions", []):
            if "regionBoundary" in fig:
                caption_bb = [fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                              fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]]
                region_bb = [fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                             fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]]
                caption = fig["caption"]
            else:
                bb = fig["boundary"]
                caption_bb = [bb["x1"], bb["y1"], bb["x2"], bb["y2"]]
                caption = fig["text"]; region_bb = None
            figs.append(Figure(figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                              page=fig["page"] + 1, dpi=72.0, caption=caption,
                              caption_bb=caption_bb, region_bb=region_bb))
        return figs
    finally: rmtree(tmpdir)

def pair_extractions(labels, extractions):
    label_ids = {fig.get_id(): fig for fig in labels}
    ids_in_extractions = set(fig.get_id() for fig in extractions)
    for fig_id, fig in label_ids.items():
        if fig_id not in ids_in_extractions: yield fig, None
    for fig in extractions:
        fig_id = fig.get_id()
        yield label_ids.get(fig_id), fig

def grade_extractions(annotations, extractions):
    true_figs = annotations["figures"]
    ext_figs = [ex for ex in extractions if ex.page in annotations["pages_annotated"]]
    evaluated = []
    for true_fig, ext_fig in pair_extractions(true_figs, ext_figs):
        if ext_fig is None: error = Error.missing
        elif ext_fig.caption_bb is None: error = Error.wrong_caption_no_region
        elif true_fig is None:
            error = Error.false_positive_no_region if ext_fig.region_bb is None else Error.false_positive
        else:
            true_cap, true_reg = true_fig.caption_bb, true_fig.region_bb
            ext_cap, ext_reg = ext_fig.caption_bb, ext_fig.region_bb
            cap_correct = box_overlap(ext_cap, true_cap)[0] >= UNION_INTERSECT_OVERLAP_THRESH
            if ext_reg is None:
                error = Error.right_caption_no_region if cap_correct else Error.wrong_caption_no_region
            else:
                reg_correct = box_overlap(ext_reg, true_reg)[0] >= UNION_INTERSECT_OVERLAP_THRESH
                if not reg_correct and not cap_correct: error = Error.wrong_caption_and_region
                elif not reg_correct: error = Error.wrong_region_box
                elif not cap_correct: error = Error.wrong_caption_box
                else: error = Error.correct
        evaluated.append(EvaluatedFigure(true_fig, ext_fig, error, ""))
    return evaluated

def main():
    annotations = load_annotations()
    doc_ids = sorted(annotations.keys())

    # Only check docs where Zig != Scala
    diffs = []
    for doc_id in doc_ids:
        ann = annotations[doc_id]
        pdf_path = ann["pdf_path"]
        zig_figs = run_zig(pdf_path)
        scala_figs = run_scala(pdf_path)
        zig_eval = grade_extractions(ann, zig_figs)
        scala_eval = grade_extractions(ann, scala_figs)

        for ze, se in zip(zig_eval, scala_eval):
            if ze.true_figure is None: continue
            if se.error == Error.correct and ze.error != Error.correct:
                zi = next((f for f in zig_figs if f.name == ze.true_figure.name and f.page == ze.true_figure.page), None)
                si = next((f for f in scala_figs if f.name == se.true_figure.name and f.page == se.true_figure.page), None)
                tr = ze.true_figure.region_bb
                zr = zi.region_bb if zi else None
                sr = si.region_bb if si else None
                zc = zi.caption_bb if zi else None
                sc = si.caption_bb if si else None
                diffs.append((doc_id, ze.true_figure.page, ze.true_figure.name, ze.error.name,
                              tr, zr, sr, zc, sc))

    print(f"Found {len(diffs)} cases where Scala correct, Zig not:")
    by_type = Counter(d[3] for d in diffs)
    for err_type, count in by_type.most_common():
        print(f"  {err_type}: {count}")

    print(f"\n{'Doc':20s} {'Pg':4s} {'Fig':6s} {'Zig Error':25s} {'True Region':28s} {'Scala Region':28s} {'Zig Region':28s}")
    print("-" * 160)
    for d in diffs:
        doc_id, page, name, err, tr, zr, sr, zc, sc = d
        tr_s = f"[{tr[0]:.0f},{tr[1]:.0f},{tr[2]:.0f},{tr[3]:.0f}]" if tr else "N/A"
        sr_s = f"[{sr[0]:.0f},{sr[1]:.0f},{sr[2]:.0f},{sr[3]:.0f}]" if sr else "N/A"
        zr_s = f"[{zr[0]:.0f},{zr[1]:.0f},{zr[2]:.0f},{zr[3]:.0f}]" if zr else "RCNR"
        print(f"{doc_id:20s} {page:<4d} {name:6s} {err:25s} {tr_s:28s} {sr_s:28s} {zr_s:28s}")

if __name__ == "__main__":
    main()