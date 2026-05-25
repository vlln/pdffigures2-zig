#!/usr/bin/env python3
"""Diagnose a specific S2 document: compare Zig output vs annotations vs Scala output."""
import sys, os, json, tempfile
from os.path import join, dirname, isfile
from subprocess import check_output, call, DEVNULL
from shutil import rmtree

sys.path.insert(0, join(dirname(__file__), "..", "..", "pdffigures2", "evaluation"))
from pdffigures_utils import Figure, FigureType, str_to_fig_type, box_overlap, Error, EvaluatedFigure, scale_figure

UNION_INTERSECT_OVERLAP_THRESH = 0.8
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
ANNOTATIONS_FILE = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
                       "datasets", "s2", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation",
               "datasets", "s2", "pdfs")

doc_id = sys.argv[1] if len(sys.argv) > 1 else "d868d28d42c327a81c40d0f3bc220868ca13e2a1"

with open(ANNOTATIONS_FILE) as f:
    raw = json.load(f)

doc = raw[doc_id]
pdf_path = join(PDF_DIR, doc_id + ".pdf")
print(f"Document: {doc_id}")
print(f"PDF: {pdf_path}")
print(f"Pages annotated: {doc.get('pages_annotated', 'all')}")
print()

# Run Zig
output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
zig_json = json.loads(output)

print("=== ZIG OUTPUT ===")
print(f"Figures: {len(zig_json.get('figures', []))}")
for fig in zig_json.get("figures", []):
    cb = fig["captionBoundary"]
    rb = fig["regionBoundary"]
    print(f"  {fig['name']} page={fig['page']+1} figType={fig['figType']}")
    print(f"    caption: [{cb['x1']:.0f}, {cb['y1']:.0f}, {cb['x2']:.0f}, {cb['y2']:.0f}]")
    print(f"    region:  [{rb['x1']:.0f}, {rb['y1']:.0f}, {rb['x2']:.0f}, {rb['y2']:.0f}]")
    print(f"    caption_text: {fig.get('caption', '')[:100]}")

print(f"\nRegionless captions: {len(zig_json.get('regionless-captions', []))}")
for fig in zig_json.get("regionless-captions", []):
    bb = fig["boundary"]
    print(f"  {fig['name']} page={fig['page']+1} figType={fig['figType']}")
    print(f"    boundary: [{bb['x1']:.0f}, {bb['y1']:.0f}, {bb['x2']:.0f}, {bb['y2']:.0f}]")
    print(f"    text: {fig.get('text', '')[:100]}")

print()

# Show annotations
print("=== ANNOTATIONS ===")
for f in doc["figures"]:
    cb = f["caption_bb"]
    rb = f.get("region_bb")
    print(f"  {f['name']} page={f['page']} figType={f['figure_type']}")
    print(f"    caption: [{cb[0]:.0f}, {cb[1]:.0f}, {cb[2]:.0f}, {cb[3]:.0f}]")
    if rb:
        print(f"    region:  [{rb[0]:.0f}, {rb[1]:.0f}, {rb[2]:.0f}, {rb[3]:.0f}]")
    print(f"    caption_text: {f['caption'][:100]}")
    print(f"    dpi: {f['dpi']}")

# Pair and grade
print("\n=== GRADING ===")
def make_fig(f, dpi_scale=True):
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
    if dpi_scale:
        caption_bb, region_bb = scale_figure(fig, 72.0)
        fig.caption_bb = caption_bb
        fig.region_bb = region_bb
        fig.dpi = 72.0
    return fig

true_figs = [make_fig(f) for f in doc["figures"]]

zig_figs = []
for fig in zig_json.get("figures", []):
    zig_figs.append(Figure(
        figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
        page=fig["page"] + 1, dpi=72.0, caption=fig.get("caption", ""),
        caption_bb=[fig["captionBoundary"]["x1"], fig["captionBoundary"]["y1"],
                    fig["captionBoundary"]["x2"], fig["captionBoundary"]["y2"]],
        region_bb=[fig["regionBoundary"]["x1"], fig["regionBoundary"]["y1"],
                   fig["regionBoundary"]["x2"], fig["regionBoundary"]["y2"]],
    ))
for fig in zig_json.get("regionless-captions", []):
    bb = fig["boundary"]
    zig_figs.append(Figure(
        figure_type=str_to_fig_type(fig["figType"]), name=fig["name"],
        page=fig["page"] + 1, dpi=72.0, caption=fig.get("text", ""),
        caption_bb=[bb["x1"], bb["y1"], bb["x2"], bb["y2"]], region_bb=None,
    ))

# Pairing
label_ids = {fig.get_id(): fig for fig in true_figs}
ext_ids = {fig.get_id(): fig for fig in zig_figs}
print(f"Annotation figure IDs: {list(label_ids.keys())}")
print(f"Zig figure IDs: {list(ext_ids.keys())}")

for true_fig in true_figs:
    fid = true_fig.get_id()
    if fid not in ext_ids:
        print(f"\n  {fid}: MISSING (not in Zig output)")
        # Check if there are any figures on the same page
        same_page = [f for f in zig_figs if f.page == true_fig.page]
        print(f"    Zig figures on same page {true_fig.page}: {[f.get_id() for f in same_page]}")
    else:
        ext_fig = ext_ids[fid]
        cap_iou = box_overlap(ext_fig.caption_bb, true_fig.caption_bb)[0] if ext_fig.caption_bb and true_fig.caption_bb else 0
        reg_iou = box_overlap(ext_fig.region_bb, true_fig.region_bb)[0] if ext_fig.region_bb and true_fig.region_bb else 0
        cap_ok = cap_iou >= UNION_INTERSECT_OVERLAP_THRESH
        reg_ok = reg_iou >= UNION_INTERSECT_OVERLAP_THRESH
        status = "CORRECT" if (cap_ok and reg_ok) else f"cap_iou={cap_iou:.3f} reg_iou={reg_iou:.3f}"
        print(f"\n  {fid}: {status}")
        print(f"    True caption:  [{true_fig.caption_bb[0]:.0f}, {true_fig.caption_bb[1]:.0f}, {true_fig.caption_bb[2]:.0f}, {true_fig.caption_bb[3]:.0f}]")
        print(f"    Zig caption:   [{ext_fig.caption_bb[0]:.0f}, {ext_fig.caption_bb[1]:.0f}, {ext_fig.caption_bb[2]:.0f}, {ext_fig.caption_bb[3]:.0f}]")
        if true_fig.region_bb and ext_fig.region_bb:
            print(f"    True region:   [{true_fig.region_bb[0]:.0f}, {true_fig.region_bb[1]:.0f}, {true_fig.region_bb[2]:.0f}, {true_fig.region_bb[3]:.0f}]")
            print(f"    Zig region:    [{ext_fig.region_bb[0]:.0f}, {ext_fig.region_bb[1]:.0f}, {ext_fig.region_bb[2]:.0f}, {ext_fig.region_bb[3]:.0f}]")

# Check for figures Zig found that annotations don't have
for ext_fig in zig_figs:
    fid = ext_fig.get_id()
    if fid not in label_ids:
        print(f"\n  {fid}: FALSE POSITIVE (not in annotations)")