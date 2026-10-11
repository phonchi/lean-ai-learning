from pathlib import Path
import subprocess, os, json, shutil
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/"verification/teaching-snippets"
OUT.mkdir(parents=True,exist_ok=True)
cases={
"tactic-capabilities": ("import Mathlib.Tactic.Linarith\nimport Mathlib.Tactic.Positivity\nimport Mathlib.Basic.Real.Basic\nexample (a b : ℝ) : (a-b)*(a+b)=a^2-b^2 := by linarith\nexample (x : ℝ) (h : 0 ≤ x) : 0 ≤ x + 1 := by positivity\n", True),
"matrix-names": ("import Course.Projection\n#check Matrix.mulVec\n#check dotProduct\n#check Fin.sum_univ_two\n",True),
"odd-sum-variants": ("import Course.Induction\nimport Mathlib.Algebra.BigOperators.Intervals\ntheorem odd_sum_succ_check (n : ℕ) : ∑ k ∈ Finset.range (n + 1), (2 * k + 1) = (n + 1) ^ 2 := by\n  exact Course.odd_sum (n + 1)\ntheorem odd_sum_Icc_check (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (2 * k - 1) = n ^ 2 := by\n  induction n with\n  | zero => simp\n  | succ n ih =>\n    rw [Finset.sum_Icc_succ_top (by omega), ih]\n    have h : 2 * (n + 1) - 1 = 2 * n + 1 := by omega\n    rw [h]\n    ring\n",True),
"invalid-matrix-name": ("import Course.Projection\n#check Matrix.dotProduct\n",False),
}
env=dict(os.environ)
local_lake=ROOT/".tools/elan/bin/lake"
lake=str(local_lake) if local_lake.exists() else shutil.which("lake")
if not lake:raise SystemExit("請先安裝elan。")
if local_lake.exists():env["ELAN_HOME"]=str(ROOT/".tools/elan")
records=[]
for name,(source,success) in cases.items():
 (OUT/(name+".lean")).write_text(source)
 result=subprocess.run([lake,"env","lean","--stdin"],input=source,cwd=ROOT/"lean-examples",env=env,text=True,capture_output=True,timeout=120)
 output=result.stdout+result.stderr
 (OUT/(name+".log")).write_text(output)
 passed=(result.returncode==0)==success
 records.append({"name":name,"expected_success":success,"exit_code":result.returncode,"passed":passed})
 print(name,passed,flush=True)
(OUT/"results.json").write_text(json.dumps({"passed":all(r["passed"] for r in records),"checks":records},ensure_ascii=False,indent=2)+"\n")
if not all(r["passed"] for r in records):raise SystemExit(1)
