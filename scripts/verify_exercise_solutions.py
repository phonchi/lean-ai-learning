#!/usr/bin/env python3
"""逐一編譯 verification/exercise-solutions/*.lean（頁面中保留練習的參考解答）；要求無錯誤、無 sorry。"""
import json, os, re, shutil, subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIR = ROOT / "verification" / "exercise-solutions"
env = dict(os.environ)
local = ROOT / ".tools" / "elan"
if (local / "bin" / "lake").exists():
    env["ELAN_HOME"] = str(local)
    env["PATH"] = str(local / "bin") + os.pathsep + env.get("PATH", "")
if not shutil.which("lake", path=env["PATH"]):
    raise SystemExit("請先安裝 elan。")
records = []
for f in sorted(DIR.glob("*.lean")):
    proc = subprocess.run(["lake", "env", "lean", str(f)], cwd=ROOT / "lean-examples", env=env, text=True, capture_output=True, timeout=600)
    out = proc.stdout + proc.stderr
    f.with_suffix(".log").write_text(out)
    clean = proc.returncode == 0 and not re.search(r"\bsorry\b|error", out) and not re.search(r"\bsorry\b", f.read_text())
    records.append({"file": f.name, "exit_code": proc.returncode, "passed": clean})
    print(f.name, "通過" if clean else "失敗", flush=True)
(DIR / "results.json").write_text(json.dumps({"passed": all(r["passed"] for r in records), "checks": records}, ensure_ascii=False, indent=2) + "\n")
if not all(r["passed"] for r in records):
    raise SystemExit(1)
