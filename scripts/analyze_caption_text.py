#!/usr/bin/env python3
"""
Compare caption text between Zig, Scala, and Ground Truth annotations.
Reports missing/extra characters for each caption.
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


def get_zig_captions(pdf_path):
    out = check_output([ZIG_BIN, pdf_path], stderr=DEVNULL)
    data = json.loads(out)
    caps = {}
    for f in data.get("figures", []):
        key = (f["figType"], f["name"], f["page"] + 1)  # Zig now 0-indexed
        caps[key] = f["caption"]
    for f in data.get("regionless-captions", []):
        key = (f["figType"], f["name"], f["page"] + 1)
        caps[key] = f.get("text", "")
    return caps


def get_scala_captions(pdf_path):
    tmp = tempfile.mkdtemp()
    try:
        call(["java", "-Djava.awt.headless=true", "-jar", SCALA_JAR,
              "-d", tmp + "/", "-c", "-e", "-q", pdf_path],
             stdout=DEVNULL, stderr=DEVNULL)
        doc_id = pdf_path[:pdf_path.rfind(".")].split("/")[-1]
        jpath = tmp + "/" + doc_id + ".json"
        if not isfile(jpath):
            return {}
        with open(jpath) as f:
            data = json.load(f)
        caps = {}
        for f in data.get("figures", []):
            key = (f["figType"], f["name"], f["page"] + 1)
            caps[key] = f["caption"]
        for f in data.get("regionless-captions", []):
            key = (f["figType"], f["name"], f["page"] + 1)
            caps[key] = f.get("text", "")
        return caps
    finally:
        rmtree(tmp)


def get_truth():
    with open(ANNOTS) as f:
        ann = json.load(f)
    truth = {}
    for doc_id, doc in ann.items():
        if isfile(join(PDF_DIR, doc_id + ".pdf")):
            truth[doc_id] = {}
            for f in doc["figures"]:
                key = (f["figure_type"], f["name"], f["page"])
                capt = f.get("caption", "")
                truth[doc_id][key] = capt
    return truth


def main():
    truth = get_truth()

    zig_shorter = []
    zig_longer = []
    zig_diff_chars = []

    for doc_id in sorted(truth.keys()):
        pdf_path = join(PDF_DIR, doc_id + ".pdf")
        t_data = truth[doc_id]
        z_data = get_zig_captions(pdf_path)
        s_data = get_scala_captions(pdf_path)

        for key, t_cap in sorted(t_data.items()):
            ft, name, page = key
            z_cap = z_data.get(key, "")
            s_cap = s_data.get(key, "")

            t_len = len(t_cap)
            z_len = len(z_cap)
            s_len = len(s_cap)

            zig_diff = z_len - t_len
            scala_diff = s_len - t_len

            if abs(zig_diff) > 5 or abs(scala_diff) > 5:
                print(f"\n{doc_id} {ft} {name} p{page}:")
                print(f"  GT({t_len:4d}): {t_cap[:200]}")
                print(f"  Z ({z_len:4d}, {zig_diff:+d}): {z_cap[:200]}")
                print(f"  S ({s_len:4d}, {scala_diff:+d}): {s_cap[:200]}")

            if zig_diff < -5:
                zig_shorter.append((doc_id, ft, name, page, zig_diff))
            elif zig_diff > 5:
                zig_longer.append((doc_id, ft, name, page, zig_diff))

    print(f"\n=== Summary ===")
    print(f"Zig shorter than GT by >5 chars: {len(zig_shorter)}")
    for item in zig_shorter:
        print(f"  {item[0]} {item[1]} {item[2]} p{item[3]}: {item[4]:+d}")
    print(f"Zig longer than GT by >5 chars: {len(zig_longer)}")
    for item in zig_longer:
        print(f"  {item[0]} {item[1]} {item[2]} p{item[3]}: {item[4]:+d}")


if __name__ == "__main__":
    main()