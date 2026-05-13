#!/usr/bin/env python3
"""Download S2 dataset PDFs from Semantic Scholar S3."""
import sys, os, json, time, urllib.request
from os.path import join, dirname, isfile, exists
from concurrent.futures import ThreadPoolExecutor, as_completed

S2_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "s2")
PDF_DIR = join(S2_DIR, "pdfs")
DOC_IDS_FILE = join(S2_DIR, "doc_ids.txt")
BASE_URL = "http://s3-us-west-2.amazonaws.com/ai2-s2-pdfs/"

def get_urls():
    urls = {}
    with open(DOC_IDS_FILE) as f:
        for line in f:
            line = line.rstrip()
            if " " in line:
                doc_id, url = line.split(" ", 1)
                urls[doc_id] = url
            else:
                doc_id = line
                urls[doc_id] = BASE_URL + doc_id[:4] + "/" + doc_id[4:] + ".pdf"
    return urls

def download(doc_id, url, max_retries=3):
    path = join(PDF_DIR, doc_id + ".pdf")
    if isfile(path):
        return doc_id, True, "already_exists"
    for attempt in range(max_retries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "pdffigures2-benchmark/1.0"})
            with urllib.request.urlopen(req, timeout=60) as resp:
                data = resp.read()
            with open(path, "wb") as f:
                f.write(data)
            return doc_id, True, "ok"
        except Exception as e:
            if attempt == max_retries - 1:
                return doc_id, False, str(e)
            time.sleep(2 ** attempt)
    return doc_id, False, "unknown"

def main():
    os.makedirs(PDF_DIR, exist_ok=True)
    urls = get_urls()
    print(f"Total documents: {len(urls)}")
    existing = len([f for f in os.listdir(PDF_DIR) if f.endswith(".pdf")])
    print(f"Already downloaded: {existing}")
    to_download = {k: v for k, v in urls.items() if not isfile(join(PDF_DIR, k + ".pdf"))}
    print(f"To download: {len(to_download)}")

    if len(to_download) == 0:
        print("All PDFs already downloaded.")
        return

    success, fail = 0, 0
    with ThreadPoolExecutor(max_workers=8) as pool:
        futures = {pool.submit(download, did, url): did for did, url in to_download.items()}
        for i, future in enumerate(as_completed(futures)):
            doc_id, ok, msg = future.result()
            if ok:
                success += 1
            else:
                fail += 1
                print(f"  FAIL {doc_id}: {msg}")
            if (i + 1) % 50 == 0:
                print(f"  Progress: {i+1}/{len(to_download)} (success={success}, fail={fail})")

    print(f"\nDone. Success: {success}, Failed: {fail}")

if __name__ == "__main__":
    main()