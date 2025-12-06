#!/usr/bin/env python3

"""
Parse Lynis security audit reports and extract relevant information for analysis.

Author: Joel Whissel
"""

import os
import re


def extract_score(log):
    score_pattern = re.compile(r"Hardening index\s*:\s*(\d+)\b")

    for line in log:
        match = score_pattern.search(line)
        if match:
            return int(match.group(1))

    raise ValueError("Hardening index not found in log.")


def main():
    log_path = os.getenv("LOG_FOLDER")

    if not log_path:
        raise RuntimeError("LOG_FOLDER  is not set.")

    with open(os.path.join(log_path, "before_audit.log"), "r") as file:
        before_log = file.readlines()

    with open(os.path.join(log_path, "after_audit.log"), "r") as file:
        after_log = file.readlines()

    before_score = extract_score(before_log)
    after_score = extract_score(after_log)

    print("Hardening index before hardening: ", before_score)
    print("Hardening index after hardening: ", after_score)
    print("Improvement in hardening index: ", after_score - before_score)


if __name__ == "__main__":
    main()