#!/usr/bin/env python3
"""Dump raw text blocks and graphics for a specific page using PyMuPDF (MuPDF).
Then compare with Zig pipeline and Scala/PDFBox extraction results."""
import sys, json, os
from subprocess import check_output, DEVNULL, call
from os.path import join, dirname, isfile
import tempfile, shutil

import fitz  # PyMuPDF

ZIG_BIN = join(dirname(__file__), "zig-out/bin/pdffigures2")
SCALA_JAR = join(dirname(__file__), "..", "pdffigures2", "pdffigures2.jar")


def dump_mupdf_raw(pdf_path, page_num):
    """Dump raw MuPDF text blocks and drawings for a specific page (1-indexed)."""
    doc = fitz.open(pdf_path)
    page = doc[page_num - 1]  # fitz uses 0-indexed pages

    print(f"\n{'='*70}")
    print(f"MuPDF RAW: page {page_num} of {pdf_path.split('/')[-1]}")
    print(f"Page bounds: {page.rect}")

    # Text blocks from fz_stext_page
    print(f"\n--- Text Blocks ({len(page.get_text('blocks'))} blocks) ---")
    blocks = page.get_text("blocks")
    for i, b in enumerate(blocks):
        x0, y0, x1, y1, text, block_type, block_no = b
        text_short = text[:120].replace("\n", "\\n") if text else "(no text)"
        print(f"  B[{i}] type={block_type} [{x0:.1f},{y0:.1f},{x1:.1f},{y1:.1f}] "
              f"w={x1-x0:.1f} h={y1-y0:.1f} area={(x1-x0)*(y1-y0):.0f} "
              f"text={text_short!r}")

    # Text words from fz_stext_page
    words = page.get_text("words")
    print(f"\n--- Text Words ({len(words)} words) ---")
    for i, w in enumerate(words[:50]):
        x0, y0, x1, y1, text, *_ = w
        print(f"  W[{i}] [{x0:.1f},{y0:.1f},{x1:.1f},{y1:.1f}] text={text!r}")
    if len(words) > 50:
        print(f"  ... ({len(words) - 50} more words)")

    # Drawings (vector graphics via fz_device)
    drawings = page.get_drawings()
    print(f"\n--- Drawings ({len(drawings)} paths/drawings) ---")
    for i, d in enumerate(drawings):
        rect = d["rect"]
        area = (rect.x1 - rect.x0) * (rect.y1 - rect.y0)
        items = d.get("items", [])
        n_items = len(items)
        print(f"  D[{i}] [{rect.x0:.1f},{rect.y0:.1f},{rect.x1:.1f},{rect.y1:.1f}] "
              f"w={rect.x1-rect.x0:.1f} h={rect.y1-rect.y0:.1f} area={area:.0f} "
              f"fill={d.get('fill')} even_odd={d.get('even_odd')} items={n_items}")

    # Images
    images = page.get_images(full=True)
    print(f"\n--- Images ({len(images)} embedded) ---")
    for i, img in enumerate(images):
        print(f"  I[{i}] xref={img[0]} size={img[2]}x{img[3]}")

    doc.close()


def dump_zig_pipeline(pdf_path, page_num):
    """Run Zig extractor and show what it extracted for a specific page."""
    output = check_output([ZIG_BIN, pdf_path], stderr=DEVNULL)
    data = json.loads(output)

    print(f"\n{'='*70}")
    print(f"ZIG PIPELINE: page {page_num}")

    # We don't have raw paragraph data from the JSON output.
    # But we can show what figures/captions Zig found.
    figs = [f for f in data.get("figures", []) if f["page"] == page_num]
    rl = [f for f in data.get("regionless-captions", []) if f["page"] == page_num]
    print(f"  Figures: {len(figs)}, Regionless: {len(rl)}")
    for f in figs:
        r = f["regionBoundary"]
        c = f["captionBoundary"]
        print(f"  {f['figType']} {f['name']}: region=[{r['x1']:.1f},{r['y1']:.1f},{r['x2']:.1f},{r['y2']:.1f}] caption=[{c['x1']:.1f},{c['y1']:.1f},{c['x2']:.1f},{c['y2']:.1f}]")
    for f in rl:
        b = f["boundary"]
        print(f"  {f['figType']} {f['name']} (regionless): caption=[{b['x1']:.1f},{b['y1']:.1f},{b['x2']:.1f},{b['y2']:.1f}]")


def dump_scala_pipeline(pdf_path, page_num):
    """Run Scala extractor and show results for comparison."""
    tmpdir = tempfile.mkdtemp()
    try:
        prefix = tmpdir + "/"
        ret = call(["java", "-Djava.awt.headless=true", "-jar", SCALA_JAR,
                    "-d", prefix, "-e", "-q", "-c", pdf_path],
                   stdout=DEVNULL, stderr=DEVNULL)
        if ret != 0:
            print("  Scala JAR failed")
            return

        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        json_path = prefix + doc_id + ".json"
        if not isfile(json_path):
            print("  Scala produced no output")
            return

        with open(json_path) as f:
            data = json.load(f)

        print(f"\n{'='*70}")
        print(f"SCALA PIPELINE: page {page_num} (Scala uses 0-indexed pages)")

        figs = [f for f in data.get("figures", []) if f["page"] + 1 == page_num]
        rl = [f for f in data.get("regionless-captions", []) if f["page"] + 1 == page_num]
        print(f"  Figures: {len(figs)}, Regionless: {len(rl)}")
        for f in figs:
            r = f["regionBoundary"]
            c = f["captionBoundary"]
            print(f"  {f['figType']} {f['name']}: region=[{r['x1']:.1f},{r['y1']:.1f},{r['x2']:.1f},{r['y2']:.1f}] caption=[{c['x1']:.1f},{c['y1']:.1f},{c['x2']:.1f},{c['y2']:.1f}]")
        for f in rl:
            b = f["boundary"]
            print(f"  {f['figType']} {f['name']} (regionless): caption=[{b['x1']:.1f},{b['y1']:.1f},{b['x2']:.1f},{b['y2']:.1f}]")
    finally:
        shutil.rmtree(tmpdir)


def main():
    if len(sys.argv) < 2:
        pdf_dir = join(dirname(__file__), "..", "pdffigures2", "evaluation",
                       "datasets", "conference", "pdfs")
        print(f"Usage: {sys.argv[0]} <pdf_path> [page_num]")
        print(f"  pdf_dir: {pdf_dir}")
        # Default to icml12_5 page 2
        pdf_path = join(pdf_dir, "icml12_5.pdf")
        page_num = 2
        print(f"Using default: {pdf_path} page {page_num}")
    else:
        pdf_path = sys.argv[1]
        page_num = int(sys.argv[2]) if len(sys.argv) > 2 else 2

    if not isfile(pdf_path):
        print(f"Error: {pdf_path} not found")
        sys.exit(1)

    dump_mupdf_raw(pdf_path, page_num)
    dump_zig_pipeline(pdf_path, page_num)
    dump_scala_pipeline(pdf_path, page_num)


if __name__ == "__main__":
    main()