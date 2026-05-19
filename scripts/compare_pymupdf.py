#!/usr/bin/env python3
"""Compare figure/image extraction: pdffigures2 (Zig) vs pymupdf4llm/pymupdf."""

import sys, os, json
from os.path import join, dirname, isfile
from subprocess import run, DEVNULL
from collections import defaultdict

ZIG_BIN = join(dirname(__file__), "..", "zig-out", "bin", "pdffigures2")
PDF_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "pdfs")
ANNOTATIONS = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "conference", "annotations.json")

def load_annotations():
    with open(ANNOTATIONS) as f:
        return {k: v for k, v in json.load(f).items()
                if isfile(join(PDF_DIR, k + ".pdf"))}

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
            "page": fig["page"], "caption_bb": [bb["x1"], bb["y1"], bb["x2"], bb["y2"]],
            "region_bb": None, "regionless": True,
        })
    return figures

def extract_images_pymupdf(pdf_path):
    """Use low-level pymupdf to get image info: page, bbox, size."""
    import pymupdf
    doc = pymupdf.open(pdf_path)
    images = []
    for page_num in range(doc.page_count):
        page = doc[page_num]
        img_list = page.get_images(full=True)
        for img in img_list:
            xref = img[0]
            # Get image bbox
            bbox = page.get_image_bbox(img)
            if bbox is None:
                continue
            w = img[2]  # width
            h = img[3]  # height
            images.append({
                "page": page_num,
                "xref": xref,
                "bbox": list(bbox),  # [x0, y0, x1, y1]
                "width": w,
                "height": h,
                "area": abs(bbox[2] - bbox[0]) * abs(bbox[3] - bbox[1]),
            })
    doc.close()
    return images

def extract_images_pymupdf4llm(pdf_path, tmpdir):
    """Use pymupdf4llm to_markdown with write_images."""
    import pymupdf4llm
    import pymupdf
    image_dir = join(tmpdir, "images")

    # Use the underlying layout parser directly to get image info
    doc = pymupdf.open(pdf_path)
    page_count = doc.page_count
    doc.close()

    # Run to_markdown to extract images
    md_text = pymupdf4llm.to_markdown(
        pdf_path, write_images=True, image_path=image_dir, image_format="png",
        show_progress=False,
    )

    # Count extracted images and get markdown image references
    if isfile(image_dir) or not os.path.exists(image_dir):
        img_count = 0
    else:
        img_count = len([f for f in os.listdir(image_dir) if f.endswith(".png")])

    # Parse markdown for image references per page
    page_images = defaultdict(int)
    for line in md_text.split("\n"):
        if line.startswith("-----") and "Page" in line:
            current_page = None
        if line.startswith("![](images/"):
            page_images[current_page or 0] += 1

    return img_count, page_images

def run_comparison():
    annotations = load_annotations()
    doc_ids = sorted(annotations.keys())
    print(f"Comparing {len(doc_ids)} PDFs: pdffigures2-zig vs pymupdf/pymupdf4llm\n")

    total_annotated = 0
    total_zig = 0
    total_pymupdf = 0
    total_pymupdf_small = 0  # images < 10% of page area (likely not figures)
    total_zig_no_figs = 0
    total_pymupdf_no_imgs = 0

    for i, doc_id in enumerate(doc_ids):
        pdf_path = join(PDF_DIR, doc_id + ".pdf")

        # pdffigures2
        zig_figs = run_pdffigures2(pdf_path)

        # pymupdf raw images
        pymu_imgs = extract_images_pymupdf(pdf_path)

        # Filter: only count "significant" images (> 5% of a typical page area)
        # Typical page: 612 x 792 pt = 484,704 pt². 5% = ~24,000 pt²
        MIN_IMG_AREA = 5000  # ~0.3in × 0.3in at 72dpi
        sig_imgs = [img for img in pymu_imgs if img["area"] > MIN_IMG_AREA]

        zig_per_page = defaultdict(int)
        for fig in zig_figs:
            zig_per_page[fig["page"]] += 1

        pymu_per_page = defaultdict(int)
        for img in sig_imgs:
            pymu_per_page[img["page"]] += 1

        n_annotated = len(annotations[doc_id]["figures"])
        n_zig = len(zig_figs)
        n_pymu_all = len(pymu_imgs)
        n_pymu_sig = len(sig_imgs)

        total_annotated += n_annotated
        total_zig += n_zig
        total_pymupdf += n_pymu_sig
        total_pymupdf_small += n_pymu_all - n_pymu_sig
        if n_zig == 0: total_zig_no_figs += 1
        if n_pymu_sig == 0: total_pymupdf_no_imgs += 1

        print(f"[{i+1:2d}/{len(doc_ids)}] {doc_id:12s}  Annotated: {n_annotated:2d}  "
              f"Zig: {n_zig:2d}  PyMuPDF(imgs): {n_pymu_all:2d} (sig: {n_pymu_sig:2d})")

    print(f"\n{'='*60}")
    print(f"SUMMARY")
    print(f"{'='*60}")
    print(f"  Total annotated figures:      {total_annotated}")
    print(f"  pdffigures2-zig detections:   {total_zig}")
    print(f"  PyMuPDF significant images:   {total_pymupdf}  (+{total_pymupdf_small} small)")
    print(f"  PDFs with 0 zig detections:   {total_zig_no_figs}")
    print(f"  PDFs with 0 pymupdf images:   {total_pymupdf_no_imgs}")


if __name__ == "__main__":
    run_comparison()