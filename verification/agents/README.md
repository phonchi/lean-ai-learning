# Agent實戰紀錄

兩個隔離工作副本保留相同原題（inputs.json）、完成後proof檔與差異。

- Codex：本次主代理產生候選並執行本機Lean，不冒稱另一個CLI session。
- Claude：Opus CLI在獨立session讀取並改寫proof body；因該CLI無shell工具，編譯由Codex主代理執行。Claude當時的summary.md保留「尚未編譯」事實；最終實測以verified-summary.json與*.audit.log為準。

verify_agent_candidates.py核對statement/import/namespace不變、不引用整題答案、不用sorry/自訂公理，並把最後原始檔連同#print axioms交給Lean。共享.lake僅用於取得固定版本已編譯相依套件，不列入Git。原始模型對話保留在本機私密collab記錄，不公開。
