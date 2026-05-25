#!/usr/bin/env python3
"""Show cases where Scala detects correctly but Zig gets rcnr (right_caption_no_region)."""
import sys, os, json, tempfile
from os.path import join, dirname, isfile
from subprocess import check_output, call, DEVNULL
from shutil import rmtree

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
        figs.append(Figure(figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
                          page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
                          caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                                      fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
                          region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                                     fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]]))
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

    # Collect rcnr cases where Scala is correct
    rcnr_cases = []
    for doc_id in doc_ids:
        ann = annotations[doc_id]
        pdf_path = ann["pdf_path"]
        zig_figs = run_zig(pdf_path)
        scala_figs = run_scala(pdf_path)
        zig_eval = grade_extractions(ann, zig_figs)
        scala_eval = grade_extractions(ann, scala_figs)

        for ze, se in zip(zig_eval, scala_eval):
            if ze.true_figure is None: continue
            if se.error == Error.correct and ze.error == Error.right_caption_no_region:
                rcnr_cases.append((doc_id, se.true_figure, ze, se))

    print(f"Found {len(rcnr_cases)} rcnr cases where Scala is correct but Zig is not:")
    print(f"{'Doc':20s} {'Page':5s} {'Figure':20s} {'True Region':30s} {'Scala Region':30s}")
    print("-" * 120)
    for doc_id, true_fig, ze, se in rcnr_cases:
        tr = true_fig.region_bb
        print(f"{doc_id:20s} {true_fig.page:5d} {true_fig.name:20s} "
              f"[{tr[0]:.0f},{tr[1]:.0f},{tr[2]:.0f},{tr[3]:.0f}]")

    # Also count per doc
    from collections import Counter
    doc_counts = Counter(doc_id for doc_id, _, _, _ in rcnr_cases)
    print(f"\nPer-document breakdown:")
    for doc_id, count in doc_counts.most_common():
        print(f"  {doc_id}: {count}")

if __name__ == "__main__":
    main()