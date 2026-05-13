#!/usr/bin/env python3
"""
Analyze caption detection differences between Zig and Scala extractors.
Runs both extractors on each PDF and compares which captions each finds.
"""
import sys, os, json, tempfile
from subprocess import check_output, call, DEVNULL
from shutil import rmtree
from os.path import join, dirname, isfile

ZIG_BIN = join(dirname(__file__), "zig-out/bin/pdffigures2")
SCALA_JAR = join(dirname(__file__), "..", "pdffigures2", "pdffigures2.jar")
ANNOTS = join(dirname(__file__), "..", "pdffigures2", "evaluation",
              "datasets", "conference", "annotations.json")
PDF_DIR = join(dirname(__file__), "..", "pdffigures2", "evaluation",
               "datasets", "conference", "pdfs")


def get_zig_figs(pdf_path):
    out = check_output([ZIG_BIN, pdf_path], stderr=DEVNULL)
    data = json.loads(out)
    figs = {}
    for f in data.get("figures", []):
        figs[(f["figType"], f["name"], f["page"] + 1)] = f
    for f in data.get("regionless-captions", []):
        figs[(f["figType"], f["name"], f["page"] + 1)] = f
    return figs


def get_scala_figs(pdf_path):
    tmp = tempfile.mkdtemp()
    try:
        call(["java", "-Djava.awt.headless=true", "-jar", SCALA_JAR,
              "-d", tmp + "/", "-c", "-e", "-q", pdf_path],
             stdout=DEVNULL, stderr=DEVNULL)
        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        jpath = tmp + "/" + doc_id + ".json"
        if not isfile(jpath):
            return {}, {}
        with open(jpath) as f:
            data = json.load(f)
        figs = {(f["figType"], f["name"], f["page"] + 1): f for f in data["figures"]}
        rl = {(f["figType"], f["name"], f["page"] + 1): f for f in data["regionless-captions"]}
        return figs, rl
    finally:
        rmtree(tmp)


def get_truth():
    with open(ANNOTS) as f:
        ann = json.load(f)
    truth = {}
    for doc_id, doc in ann.items():
        if isfile(join(PDF_DIR, doc_id + ".pdf")):
            truth[doc_id] = {(f["figure_type"], f["name"], f["page"]): f
                           for f in doc["figures"]}
    return truth


def main():
    truth = get_truth()
    doc_ids = sorted(truth.keys())

    zig_missing = {}  # in truth but not in zig
    scala_missing = {}
    zig_extra = {}    # in zig but not in truth
    scala_extra = {}

    print(f"{'doc':20s} {'truth':>5s} {'zig':>5s} {'scala':>5s}  notes")
    print("-" * 60)

    for doc_id in doc_ids:
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        t_ids = set(truth[doc_id].keys())
        z_ids = set(get_zig_figs(pdf_path).keys())
        s_figs, s_rl = get_scala_figs(pdf_path)
        s_ids = set(s_figs.keys()) | set(s_rl.keys())

        z_only = z_ids - t_ids
        s_only = s_ids - t_ids
        t_z_miss = t_ids - z_ids
        t_s_miss = t_ids - s_ids

        notes = []
        if t_z_miss:
            zig_missing[doc_id] = t_z_miss
            miss_str = ",".join(f"{t}{n}p{p}" for t,n,p in sorted(t_z_miss))
            notes.append(f"Z-miss:{miss_str}")
        if t_s_miss:
            scala_missing[doc_id] = t_s_miss
            miss_str = ",".join(f"{t}{n}p{p}" for t,n,p in sorted(t_s_miss))
            notes.append(f"S-miss:{miss_str}")
        if z_only:
            zig_extra[doc_id] = z_only
            notes.append(f"Z-extra:{z_only}")
        if s_only:
            scala_extra[doc_id] = s_only
            notes.append(f"S-extra:{s_only}")

        print(f"{doc_id:20s} {len(t_ids):5d} {len(z_ids):5d} {len(s_ids):5d}  {'; '.join(notes)}")

    print(f"\n=== Summary ===")

    total_truth = sum(len(v) for v in truth.values())
    total_zig_found = total_truth - sum(len(v) for v in zig_missing.values())
    total_scala_found = total_truth - sum(len(v) for v in scala_missing.values())

    print(f"Total ground truth figures: {total_truth}")
    print(f"Zig detected:    {total_zig_found}/{total_truth} ({total_zig_found/total_truth:.0%})")
    print(f"Scala detected:  {total_scala_found}/{total_truth} ({total_scala_found/total_truth:.0%})")

    # Categorize by figure type
    def count_by_type(missing_dict):
        counts = {"Figure": 0, "Table": 0}
        for ids in missing_dict.values():
            for ft, name, page in ids:
                counts[ft] += 1
        return counts

    zc = count_by_type(zig_missing)
    sc = count_by_type(scala_missing)
    print(f"\nZig missing:   {zc['Figure']} Figures, {zc['Table']} Tables")
    print(f"Scala missing: {sc['Figure']} Figures, {sc['Table']} Tables")

    # Common missing (both miss)
    common = {}
    for doc_id in zig_missing:
        both = zig_missing[doc_id] & scala_missing.get(doc_id, set())
        if both:
            common[doc_id] = both
    total_common = sum(len(v) for v in common.values())
    print(f"\nBoth miss: {total_common} captions (likely annotation or PDF issues)")

    # Zig-specific misses (Scala finds but Zig doesn't)
    zig_only_miss = {}
    for doc_id in zig_missing:
        only = zig_missing[doc_id] - scala_missing.get(doc_id, set())
        if only:
            zig_only_miss[doc_id] = only
    total_zig_only = sum(len(v) for v in zig_only_miss.values())
    print(f"Zig-only misses: {total_zig_only} (Scala found these, Zig didn't)")
    if zig_only_miss:
        for doc_id in sorted(zig_only_miss):
            items = sorted(zig_only_miss[doc_id])
            print(f"  {doc_id}: {items}")


if __name__ == "__main__":
    main()