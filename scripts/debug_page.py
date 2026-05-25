#!/usr/bin/env python3
"""Debug page structure for a specific document to understand region proposals."""
import sys, os, json
from os.path import join, dirname, isfile
from subprocess import check_output, DEVNULL

doc_id = sys.argv[1] if len(sys.argv) > 1 else "25e03ff29865438c7f8357b1cb4fd060ee2717a6"
page_num = int(sys.argv[2]) if len(sys.argv) > 2 else 4  # 0-indexed
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "s2", "pdfs")
ZIG_BINARY = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")

pdf_path = join(PDF_DIR, doc_id + ".pdf")
output = check_output([ZIG_BINARY, pdf_path], stderr=DEVNULL)
zig_json = json.loads(output)

print(f"Document: {doc_id}")
print(f"Page {page_num + 1} (0-indexed: {page_num})")

# Show captions on this page
print("\n=== CAPTIONS ===")
for fig in zig_json.get("figures", []):
    if fig["page"] == page_num:
        cb = fig["captionBoundary"]
        print(f"  {fig['name']} figType={fig['figType']}")
        print(f"    caption: [{cb['x1']:.0f}, {cb['y1']:.0f}, {cb['x2']:.0f}, {cb['y2']:.0f}]")
        print(f"    caption_text: {fig.get('caption', '')[:120]}")

# Show figures on this page
print("\n=== FIGURE REGIONS ===")
for fig in zig_json.get("figures", []):
    if fig["page"] == page_num:
        rb = fig["regionBoundary"]
        print(f"  {fig['name']}: region=[{rb['x1']:.0f},{rb['y1']:.0f},{rb['x2']:.0f},{rb['y2']:.0f}]")

# Show regionless captions
print("\n=== REGIONLESS CAPTIONS ===")
for fig in zig_json.get("regionless-captions", []):
    if fig["page"] == page_num:
        bb = fig["boundary"]
        print(f"  {fig['name']}: boundary=[{bb['x1']:.0f},{bb['y1']:.0f},{bb['x2']:.0f},{bb['y2']:.0f}]")

# Print full JSON for this page for debugging
print("\n=== FULL PAGE OUTPUT ===")
import pprint
page_data = {
    "figures": [f for f in zig_json.get("figures", []) if f["page"] == page_num],
    "regionless-captions": [f for f in zig_json.get("regionless-captions", []) if f["page"] == page_num]
}
# Also show other pages' figures if they exist
all_pages = set()
for f in zig_json.get("figures", []):
    all_pages.add(f["page"] + 1)
for f in zig_json.get("regionless-captions", []):
    all_pages.add(f["page"] + 1)
print(f"All pages with figures/captions: {sorted(all_pages)}")

# Show ALL figures regardless of page
print("\n=== ALL FIGURES (with captions) ===")
for fig in zig_json.get("figures", []):
    cb = fig["captionBoundary"]
    rb = fig["regionBoundary"]
    print(f"  {fig['name']} page={fig['page']+1} figType={fig['figType']}")
    print(f"    caption: [{cb['x1']:.0f}, {cb['y1']:.0f}, {cb['x2']:.0f}, {cb['y2']:.0f}]")
    print(f"    region:  [{rb['x1']:.0f}, {rb['y1']:.0f}, {rb['x2']:.0f}, {rb['y2']:.0f}]")
    print(f"    caption_text: {fig.get('caption', '')[:120]}")

for fig in zig_json.get("regionless-captions", []):
    bb = fig["boundary"]
    print(f"  {fig['name']} page={fig['page']+1} (regionless) figType={fig['figType']}")
    print(f"    boundary: [{bb['x1']:.0f}, {bb['y1']:.0f}, {bb['x2']:.0f}, {bb['y2']:.0f}]")
    print(f"    text: {fig.get('text', '')[:120]}")