# 教材用真實 AI 對話紀錄（2026-10-12）

這 3 個案例是為了網站教材專門新跑的，各在 Claude Code 與 Codex 上執行一次；這裡的完整內容**刻意公開**，作為教材摘錄的依據。教材採用的就是這次執行的結果，沒有重跑，也沒有挑選。

## 執行方式

- 每次執行都在 scratch 中的獨立 Lean 專案進行：Lean／mathlib v4.34.1，`.lake/packages` 以 symlink 共用已建好的 mathlib。專案內除了 Lake 設定，只有 AI 自己寫的 `Answer.lean`。
- Claude 側用 `claude -p`（Claude Code CLI 2.1.296，非互動），model 回報為 `claude-opus-5-5`，`--permission-mode acceptEdits`，只允許 Read／Write／Edit 與 `Bash(lake env lean:*)`。
- Codex 側用 `codex exec --sandbox workspace-write`（codex-cli 0.162.0），沿用本機 config 的 model `gpt-6.1-sol`；事件流本身沒有回報 model 名稱。
- prompt 見各目錄的 `prompt.md`，模擬大學生把課本題目交給 AI。最後一行「請直接完成，不需要先反問我」是因為執行環境載有使用者的全域偏好設定。
- AI 結束後，我們另外對 `Answer.lean` 跑一次 `lake env lean`，結果記在 `independent-compile.log`（空檔＝無錯誤無警告）與 `provenance.json`。
- 公開前做了清理：`transcript.*` 只保留對話、工具呼叫與輸出；移除本機 plugin／MCP／memory 等環境設定與 `ps` 程序清單，scratch 路徑改寫成 `<scratch>`。未清理的原始輸出不公開。

## 結果摘要（6 份最終答案都通過獨立編譯，無 sorry）

| 案例 | 工具 | 實際觀察到的重點 |
| --- | --- | --- |
| quantifier（第 3 章） | Claude | 主定理寫成字面的 `¬ ∃ n, ∀ m, m ≤ n`，另附 `∀ n, ∃ m, n < m`，並宣稱兩者「等價」；但沒有在 Lean 中證明兩者等價。 |
| quantifier | Codex | 只寫 `∀ n, ∃ m, n < m`，這是課本換句話說後的正面版本。 |
| induction（第 4 章） | Claude | 用 `Icc 1 n` 與截斷減法 `2 * i - 1`，加上 `1 ≤ n`，最貼近課本；用 `omega` 處理減法。 |
| induction | Codex | 改用 `range n` 與 `2 * k + 1`。第一次編譯時 Lean 警告假設 `hn` 沒被用到，AI 把它改名成 `_hn` 讓警告消失，之後聲稱和課本「數學意義完全一致」。 |
| limits（advanced/01） | Claude | 依課本 ε/2、`max N₁ N₂` 逐步證明，並主動說明 mathlib 已有 `Filter.Tendsto.add`。 |
| limits | Codex | 第一次編譯失敗：`Unknown identifier 'abs_add'`（這個版本中名稱是 `abs_add_le`）。它接著執行的 `rg` 搜尋沒有任何輸出，之後直接改成 `abs_add_le` 並編譯通過；紀錄中看不出新名稱是從哪裡得知的。 |
