#!/usr/bin/env python3
"""
Download S2 dataset PDFs using Semantic Scholar API + direct sources.
Strategy:
  1. Query S2 API for isOpenAccess, openAccessPdf.url, externalIds.ArXiv
  2. Download from openAccessPdf.url (open access papers)
  3. Download from arxiv.org/pdf/{id} (papers with arXiv ID)
  4. Skip paywalled papers
Rate limit: 1 S2 API request/second to avoid 429.
"""
import sys, os, json, time, urllib.request
from os.path import join, dirname, isfile

S2_DIR = join(dirname(__file__), "..", "..", "pdffigures2", "evaluation", "datasets", "s2")
PDF_DIR = join(S2_DIR, "pdfs")
DOC_IDS_FILE = join(S2_DIR, "doc_ids.txt")
S2_API = "https://api.semanticscholar.org/graph/v1/paper/"

MIN_FILE_SIZE = 1024

HEADERS = {"User-Agent": "Mozilla/5.0 (compatible; pdffigures2-benchmark/1.0)"}


def is_valid(path):
    return isfile(path) and os.path.getsize(path) >= MIN_FILE_SIZE


def download_file(url, path, timeout=60):
    if isfile(path) and os.path.getsize(path) < MIN_FILE_SIZE:
        os.remove(path)
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        data = resp.read()
    if len(data) < MIN_FILE_SIZE:
        return False
    with open(path, "wb") as f:
        f.write(data)
    return True


def get_paper_info(doc_id):
    url = f"{S2_API}{doc_id}?fields=isOpenAccess,openAccessPdf,externalIds"
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read())
    is_oa = data.get("isOpenAccess", False)
    oa_url = (data.get("openAccessPdf") or {}).get("url", "") or ""
    arxiv_id = (data.get("externalIds") or {}).get("ArXiv") or ""
    return is_oa, oa_url, arxiv_id


def main():
    os.makedirs(PDF_DIR, exist_ok=True)
    with open(DOC_IDS_FILE) as f:
        all_ids = [l.rstrip().split()[0] for l in f if l.strip()]

    existing = sum(1 for did in all_ids if is_valid(join(PDF_DIR, did + ".pdf")))
    print(f"Total: {len(all_ids)}, already have: {existing}, to fetch: {len(all_ids) - existing}")

    success, skip_paywall, skip_nopdf, fail = 0, 0, 0, 0

    for i, did in enumerate(all_ids):
        path = join(PDF_DIR, did + ".pdf")
        if is_valid(path):
            success += 1
            continue

        # Step 1: Get metadata from S2 API
        try:
            is_oa, oa_url, arxiv_id = get_paper_info(did)
        except Exception as e:
            fail += 1
            if (i + 1) % 50 == 0:
                print(f"  [{i+1}/{len(all_ids)}] API error: {e}")
            time.sleep(1.0)
            continue

        # Step 2: Try to download
        downloaded = False
        if oa_url:
            try:
                downloaded = download_file(oa_url, path)
            except Exception:
                pass

        if not downloaded and arxiv_id:
            arxiv_url = f"https://arxiv.org/pdf/{arxiv_id}"
            try:
                downloaded = download_file(arxiv_url, path)
            except Exception:
                pass

        if downloaded:
            success += 1
        elif is_oa or arxiv_id:
            skip_nopdf += 1
            print(f"  MISS {did}: OA but download failed (url={oa_url[:50] if oa_url else arxiv_id})")
        else:
            skip_paywall += 1

        if (i + 1) % 50 == 0:
            print(f"  [{i+1}/{len(all_ids)}] ok={success} paywall={skip_paywall} "
                  f"nopdf={skip_nopdf} fail={fail}")

        time.sleep(1.0)  # S2 API rate limit

    print(f"\nDone: ok={success}, paywall={skip_paywall}, nopdf={skip_nopdf}, fail={fail}")


if __name__ == "__main__":
    main()