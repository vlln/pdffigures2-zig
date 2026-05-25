#!/usr/bin/env python3
"""Analyze specific WRB cases to understand region detection failures."""
import sys, os, json
from os.path import join, dirname, isfile
from subprocess import check_output, DEVNULL

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure, scale_figure

UNION_INTERSECT_OVERLAP_THRESH = 0.8
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
                       "datasets", "s2", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
               "datasets", "s2", "pdfs")

doc_id = sys.argv[1] if len(sys.argv) > 1 else "25e03ff29865438c7f8357b1cb4fd060ee2717a6"

with open(ANNOTATIONS_FILE) as f:
    raw = json.load(f)

doc = raw[doc_id]
pdf_path = join(PDF_DIR, doc_id + ".pdf")

# Get all pages annotated
pages_annotated = doc.get("pages_annotated", [])

# Run Zig
output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
zig_json = json.loads(output)

# Show all zig figures and their pages
print(f"Document: {doc_id}")
print(f"Pages annotated: {pages_annotated}")
print(f"Total pages in Zig output: max page = ...")
print()

# Show Zig figures ON ANNOTATED PAGES
print("=== ZIG FIGURES ON ANNOTATED PAGES ===")
for fig in zig_json.get("figures", []):
    zig_page = fig["page"] + 1
    if zig_page in pages_annotated:
        cb = fig["captionBoundary"]
        rb = fig["regionBoundary"]
        print(f"  {fig['name']} page={zig_page} figType={fig['figType']}")
        print(f"    caption: [{cb['x1']:.0f}, {cb['y1']:.0f}, {cb['x2']:.0f}, {cb['y2']:.0f}]")
        print(f"    region:  [{rb['x1']:.0f}, {rb['y1']:.0f}, {rb['x2']:.0f}, {rb['y2']:.0f}]")
        print(f"    caption_text: {fig.get('caption', '')[:120]}")
        print()

print("=== ANNOTATIONS ON ANNOTATED PAGES ===")
annotated_figs = [f for f in doc["figures"] if f["page"] in pages_annotated]
for f in annotated_figs:
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
    print(f"  {f['name']} page={f['page']} figType={f['figure_type']}")
    print(f"    caption: [{caption_bb[0]:.0f}, {caption_bb[1]:.0f}, {caption_bb[2]:.0f}, {caption_bb[3]:.0f}] h={caption_bb[3]-caption_bb[1]:.0f}")
    if region_bb:
        print(f"    region:  [{region_bb[0]:.0f}, {region_bb[1]:.0f}, {region_bb[2]:.0f}, {region_bb[3]:.0f}] h={region_bb[3]-region_bb[1]:.0f}")
    print()

# Grade each figure
print("=== GRADING ===")
def make_fig_from_json(fig):
    if "regionBoundary" in fig:
        return Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
            caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                        fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
            region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                       fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
        )
    else:
        bb = fig["boundary"]
        return Figure(
            figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
            page=fig["page"] + 1, dpi=72.0, caption=fig.get("text", ""),
            caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None,
        )

zig_figs = [make_fig_from_json(f) for f in zig_json.get("figures", [])]
zig_figs += [make_fig_from_json(f) for f in zig_json.get("regionless-captions", [])]

true_figs = []
for f in annotated_figs:
    fig = Figure(
        figure_type=str_to_fig_type(f["figure_type"]),
        name=f["name"], page=f["page"], dpi=f["dpi"],
        caption=f["caption"],
        caption_bb=f["caption_bb"], region_bb=f.get("region_bb"),
    )
    caption_bb, region_bb = scale_figure(fig, 72.0)
    fig.caption_bb = caption_bb
    fig.region_bb = region_bb
    fig.dpi = 72.0
    true_figs.append(fig)

# Pair by ID
label_ids = {fig.get_id(): fig for fig in true_figs}
ext_ids = {fig.get_id(): fig for fig in zig_figs}

for true_fig in true_figs:
    fid = true_fig.get_id()
    ext_fig = ext_ids.get(fid)
    if ext_fig is None:
        same_page_zig = [f for f in zig_figs if f.page == true_fig.page]
        print(f"  {fid}: MISSING - Zig figures on same page: {[(f.name, f.get_id()) for f in same_page_zig]}")
    else:
        cap_iou = box_overlap(ext_fig.caption_bb, true_fig.caption_bb)[0]
        reg_iou = box_overlap(ext_fig.region_bb, true_fig.region_bb)[0] if ext_fig.region_bb and true_fig.region_bb else 0
        cap_ok = "OK" if cap_iou >= 0.8 else f"BAD({cap_iou:.3f})"
        reg_ok = "OK" if reg_iou >= 0.8 else f"BAD({reg_iou:.3f})"
        print(f"  {fid}: cap={cap_ok} reg={reg_ok}")
        if cap_iou < 0.8 or reg_iou < 0.8:
            tc = true_fig.caption_bb
            ec = ext_fig.caption_bb
            print(f"    True cap: [{tc[0]:.0f},{tc[1]:.0f},{tc[2]:.0f},{tc[3]:.0f}] h={tc[3]-tc[1]:.0f} w={tc[2]-tc[0]:.0f}")
            print(f"    Zig cap:  [{ec[0]:.0f},{ec[1]:.0f},{ec[2]:.0f},{ec[3]:.0f}] h={ec[3]-ec[1]:.0f} w={ec[2]-ec[0]:.0f}")
            if true_fig.region_bb and ext_fig.region_bb:
                tr = true_fig.region_bb
                er = ext_fig.region_bb
                print(f"    True reg: [{tr[0]:.0f},{tr[1]:.0f},{tr[2]:.0f},{tr[3]:.0f}] h={tr[3]-tr[1]:.0f} w={tr[2]-tr[0]:.0f}")
                print(f"    Zig reg:  [{er[0]:.0f},{er[1]:.0f},{er[2]:.0f},{er[3]:.0f}] h={er[3]-er[1]:.0f} w={er[2]-er[0]:.0f}")
                # Check if Zig region is shifted vertically or horizontally
                print(f"    X diff: dx1={er[0]-tr[0]:.0f} dx2={er[2]-tr[2]:.0f} Y diff: dy1={er[1]-tr[1]:.0f} dy2={er[3]-tr[3]:.0f}")

# Also show false positives on annotated pages
print("\n=== FALSE POSITIVES (Zig figures on annotated pages not in annotations) ===")
for ext_fig in zig_figs:
    if ext_fig.page in pages_annotated and ext_fig.get_id() not in label_ids:
        print(f"  {ext_fig.get_id()}: region={ext_fig.region_bb}")