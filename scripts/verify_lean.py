#!/usr/bin/env python3
"""驗證固定版本的教材、負例、公理依賴；所有證據保存在 verification/lean。"""
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "lean-examples"
LOG = ROOT / "verification" / "lean"
LOG.mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ)
LOCAL_ELAN = ROOT / ".tools" / "elan"
if (LOCAL_ELAN / "bin" / "lake").exists():
    ENV["ELAN_HOME"] = str(LOCAL_ELAN)
    ENV["PATH"] = str(LOCAL_ELAN / "bin") + os.pathsep + ENV.get("PATH", "")
results = []

def run(label, args, expected=0):
    proc = subprocess.run(args, cwd=PROJECT, env=ENV, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (LOG / (label + ".log")).write_text(proc.stdout)
    ok = proc.returncode == 0 if expected == 0 else proc.returncode != 0
    results.append({"check": label, "command": args, "exit_code": proc.returncode, "passed": ok})
    print(label, "通過" if ok else "失敗", flush=True)
    return proc.stdout, ok

try:
    run("lean-version", ["lake", "env", "lean", "--version"])
    run("lake-version", ["lake", "--version"])
    _, built = run("build", ["lake", "build"])
    formal = sorted((PROJECT / "Course").glob("*.lean"))
    forbidden = re.compile(r"\b(sorry|admit|axiom|unsafe|native_decide)\b")
    bad = [str(p.relative_to(PROJECT)) for p in formal if forbidden.search(p.read_text())]
    results.append({"check": "formal-source", "passed": not bad, "files_with_forbidden_tokens": bad})
    names = []
    for p in formal:
        names.extend("Course." + n for n in re.findall(r"^theorem\s+(\w+)", p.read_text(), re.M))
        if built:
            run("file-" + p.stem, ["lake", "env", "lean", str(p.relative_to(PROJECT))])
    if built:
        audit = LOG / "AxiomAudit.lean"
        audit.write_text("import Course\n" + "\n".join("#print axioms " + n for n in names) + "\n")
        out, ok = run("axioms", ["lake", "env", "lean", str(audit)])
        allowed = {"propext", "Classical.choice", "Quot.sound"}
        deps = set()
        for block in re.findall(r"depends on axioms:\s*\[(.*?)\]", out, re.S):
            deps.update(x.strip() for x in block.split(",") if x.strip())
        covered = all("'" + n + "'" in out for n in names)
        results.append({"check": "axiom-policy", "passed": ok and covered and not (deps - allowed), "dependencies": sorted(deps), "theorems": names})
    for p in sorted((PROJECT / "Negative").glob("*.lean")):
        out, ok = run("negative-" + p.stem, ["lake", "env", "lean", str(p.relative_to(PROJECT))], expected=1)
        results.append({"check": "negative-diagnostic-" + p.stem, "passed": ok and "error:" in out and "type mismatch" in out.lower()})
    for p in sorted((PROJECT / "Exercises").glob("*.lean")):
        placeholder = bool(re.search(r"\bsorry\b", p.read_text()))
        out, ok = run("exercise-" + p.stem, ["lake", "env", "lean", str(p.relative_to(PROJECT))])
        results.append({"check": "exercise-placeholder-" + p.stem, "passed": placeholder and ok and "sorry" in out})
    # 獨立有理數計算僅作輔助檢查，不取代 Lean 的普遍證明。
    from fractions import Fraction
    matrix = [[Fraction(1,2)]*2 for _ in range(2)]
    product = [[sum(matrix[i][k]*matrix[k][j] for k in range(2)) for j in range(2)] for i in range(2)]
    auxiliary = product == matrix and all(sum(2*k+1 for k in range(n)) == n*n for n in range(101))
    results.append({"check": "auxiliary-exact-arithmetic", "passed": auxiliary, "odd_sum_n": [0,100], "projection_product": [[str(x) for x in row] for row in product]})
except Exception as exc:
    results.append({"check": "runner", "passed": False, "error": repr(exc)})
summary = {"timestamp_utc": datetime.now(timezone.utc).isoformat(), "toolchain": (PROJECT / "lean-toolchain").read_text().strip(), "results": results, "passed": all(r["passed"] for r in results)}
manifest = PROJECT / "lake-manifest.json"
if manifest.exists():
    summary["manifest"] = json.loads(manifest.read_text())
(LOG / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
sys.exit(0 if summary["passed"] else 1)
