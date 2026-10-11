# Lean × AI 範例專案

本專案固定 Lean `v4.34.1` 與 mathlib `v4.34.1`；`lake-manifest.json` 記錄實際 commit。所有正式答案在 `Course/`；`Exercises/` 保留待填的 `sorry`，`Negative/` 是預期無法編譯的錯誤範例，兩者皆不由 `Course.lean` 匯入。

## 本機操作

先依網站的環境設定章節安裝官方 elan，再解壓縮下載的專案。以下命令中的目錄名稱請換成實際解壓縮目錄：

```sh
cd /path/to/lean-examples
lake exe cache get
lake build
lake env lean Exercises/ProofRepair.lean
```

第一次需要下載工具鏈、依賴與 mathlib 快取。請勿修改 `lean-toolchain` 或自行升級依賴；已有 manifest 時不必 `lake update`。下載的範例專案本身不包含網站的 `.tools/` 與驗證腳本。

### 網站開發者的補充操作

只有在完整網站原始碼、且已使用網站內的 `.tools/elan` 安裝時，才從網站根目錄設定以下環境：

```sh
export ELAN_HOME="$PWD/.tools/elan"
export PATH="$ELAN_HOME/bin:$PATH"
python3 scripts/verify_lean.py
```

`verify_lean.py` 依賴完整網站目錄結構，不能直接在獨立下載的範例專案執行。它會編譯正式 library、逐檔檢查、公理稽核，確認負例失敗與練習保有 placeholder。完整紀錄位於網站的 `verification/lean/`；`summary.json` 有版本、解析後的依賴及各項結果。

## ZIP 下載者的差異比較

剛解壓、尚未修改的獨立專案可執行以下指令，建立本機比較基準：

```sh
git init
git add Course.lean Course Exercises Negative lakefile.toml lean-toolchain lake-manifest.json
```

不需要 commit、姓名／email 或遠端。修改後用 `git diff` 查看差異；檢視前不要再次 `git add`。已有 Git 紀錄的專案沿用原本基準，先保留既有修改，不要重新初始化。也可保留原始下載檔，透過 VS Code 比較。

## 三個實戰

- `Exercises/ProofRepair.lean` 對照 `Course/Logic.lean`：只修改證明，解釋診斷。
- `Exercises/OddSum.lean` 對照 `Course/Induction.lean`：從索引 0 起算，使用歸納法。
- `Exercises/Squares.lean` 對照 `Course/Squares.lean`：列表保留重複值，空列表也成立。

Lean 接受含 `sorry` 的檔案，因此練習檔編譯成功不代表完成。正式解答不可使用 `sorry`、`admit`、額外公理、`unsafe` 或 `native_decide`；標準基礎公理 `propext`、`Classical.choice`、`Quot.sound` 在本課程允許範圍內。仍須人工確認形式命題忠實對應原題。

## 選用本機 MCP

`mcp.example.json` 只提供範本，不會自動啟動或改寫帳號設定。學生自行決定是否把此設定加入所用 agent 的專案設定；執行指令為 `uvx lean-lsp-mcp==0.31.0`。這是本機程序，需要 `uv`、專案工具鏈及依賴；不預設遠端 MCP。模型使用方式由學生既有環境決定，本專案不開啟任何付費設定。
