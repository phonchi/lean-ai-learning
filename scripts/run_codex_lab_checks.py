"""重播本次 Codex 主代理完成的三個練習，保留原題與實際 Lean 輸出。
這不是另一個 Codex CLI session，不捏造對話紀錄。
"""
from pathlib import Path
import subprocess, os, json, difflib
ROOT=Path(__file__).resolve().parents[1]
WORK=ROOT/"verification/agents/codex"
inputs=json.loads((WORK/"inputs.json").read_text())
proofs={
"ProofRepair.lean": "intro hp\n  apply hQR\n  exact hPQ hp",
"OddSum.lean": "induction n with\n  | zero => simp\n  | succ k hk =>\n    rw [Finset.sum_range_succ, hk]\n    ring",
"Squares.lean": "induction xs with\n  | nil => simp [Course.squareSum]\n  | cons a xs ih =>\n    constructor\n    · intro h\n      change a ^ 2 + Course.squareSum xs = 0 at h\n      have hn := Course.squares_nonneg xs\n      have ha : a = 0 := by nlinarith [sq_nonneg a]\n      have ht : Course.squareSum xs = 0 := by nlinarith\n      intro x hx\n      rcases List.mem_cons.mp hx with hxa | hxs\n      · exact hxa.trans ha\n      · exact ih.mp ht x hxs\n    · intro h\n      have ha : a = 0 := h a (by simp)\n      have ht : Course.squareSum xs = 0 := ih.mpr (fun x hx => h x (by simp [hx]))\n      change a ^ 2 + Course.squareSum xs = 0\n      rw [ha, ht]\n      norm_num"
}
env=dict(os.environ)
env["ELAN_HOME"]=str(ROOT/".tools/elan")
lake=str(ROOT/".tools/elan/bin/lake")
records=[]
for name, proof in proofs.items():
 original=inputs[name]
 assert original.count("  sorry") == 1
 final=original.replace("  sorry", "  "+proof)
 (WORK/"Exercises"/name).write_text(final)
 (WORK/(name+".diff")).write_text("".join(difflib.unified_diff(original.splitlines(True),final.splitlines(True),fromfile="before/"+name,tofile="after/"+name)))
 result=subprocess.run([lake,"env","lean","Exercises/"+name],cwd=WORK,env=env,text=True,capture_output=True,timeout=240)
 output=result.stdout+result.stderr
 (WORK/(name+".log")).write_text(output)
 record={"file":name,"exit_code":result.returncode,"proof_only_change":True,"no_sorry": "sorry" not in final,"passed":result.returncode==0 and "sorry" not in output.lower()}
 records.append(record)
 print(json.dumps(record,ensure_ascii=False),flush=True)
summary={"agent":"Codex 主代理（本次工作階段）","method":"由主代理填入proof body，再用本機Lean實際編譯；不是獨立CLI對話。","checks":records,"passed":all(r["passed"] for r in records)}
(WORK/"summary.json").write_text(json.dumps(summary,ensure_ascii=False,indent=2)+"\n")
if not summary["passed"]:raise SystemExit(1)
