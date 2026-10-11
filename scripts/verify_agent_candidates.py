"""核對兩個agent候選證明的修改範圍，並以固定Lean執行與稽核公理。"""
from pathlib import Path
import subprocess, os, json, re, hashlib, difflib, shutil
ROOT=Path(__file__).resolve().parents[1]
LOCAL_LAKE=ROOT/".tools/elan/bin/lake"
LAKE=str(LOCAL_LAKE) if LOCAL_LAKE.exists() else shutil.which("lake")
if not LAKE: raise SystemExit("請先安裝elan，並完成lean-examples的lake build。")
ENV=dict(os.environ)
if LOCAL_LAKE.exists(): ENV["ELAN_HOME"]=str(ROOT/".tools/elan")
ALLOWED={"propext","Classical.choice","Quot.sound"}
NAMES={"ProofRepair.lean":"imp_trans","OddSum.lean":"odd_sum","Squares.lean":"squares_zero"}
all_records=[]
for who in ["codex","claude"]:
 work=ROOT/"verification/agents"/who
 cache=work/".lake"
 if not cache.exists():
  target=ROOT/"lean-examples/.lake"
  if not target.exists(): raise SystemExit("請先在lean-examples執行lake build。")
  cache.symlink_to(target, target_is_directory=True)
 inputs=json.loads((work/"inputs.json").read_text())
 records=[]
 for file,name in NAMES.items():
  source=(work/"Exercises"/file).read_text()
  before=inputs[file]
  prefix,suffix=before.split("  sorry")
  locked=source.startswith(prefix) and source.endswith(suffix)
  body=source[len(prefix):len(source)-len(suffix)] if locked else ""
  clean=not re.search(r"\b(sorry|admit|axiom|unsafe|native_decide)\b",body)
  shortcut=bool(re.search(r"Course\.(imp_trans|odd_sum|squares_zero)\b",body))
  record={"file":file,"proof_only_change":locked,"no_prohibited_placeholder":clean,"no_answer_shortcut":not shortcut,"sha256":hashlib.sha256(source.encode()).hexdigest()}
  if locked and clean and not shortcut:
   result=subprocess.run([LAKE,"env","lean","--stdin"],cwd=work,env=ENV,input=source+"\n#print axioms Exercises."+name+"\n",text=True,capture_output=True,timeout=120)
   output=result.stdout+result.stderr
   (work/(file+".audit.log")).write_text(output)
   matches=re.findall(r"depends on axioms: \[(.*?)\]",output,re.S)
   axioms={a.strip() for m in matches for a in m.split(",") if a.strip()}
   evidence="does not depend on any axioms" in output or bool(matches)
   record.update({"exit_code":result.returncode,"axioms":sorted(axioms),"axioms_within_course_policy":evidence and axioms<=ALLOWED,"passed":result.returncode==0 and evidence and axioms<=ALLOWED})
  else:record["passed"]=False
  (work/(file+".diff")).write_text("".join(difflib.unified_diff(before.splitlines(True),source.splitlines(True),fromfile="before/"+file,tofile="after/"+file)))
  records.append(record)
  print(who,file,record["passed"],flush=True)
 summary={"agent":who,"verification_executor":"Codex 主代理使用固定版本Lean執行；Claude候選由Opus CLI產生，該CLI無shell工具。","checks":records,"passed":all(r["passed"] for r in records)}
 (work/"verified-summary.json").write_text(json.dumps(summary,ensure_ascii=False,indent=2)+"\n")
 all_records.extend(records)
if not all(r["passed"] for r in all_records):raise SystemExit(1)
