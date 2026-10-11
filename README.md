# Lean × AI

給大學生與研究生的繁體中文 Lean 4 自學網站。8章、3個完整實戰、2個進階範例。

[開啟學習網站](https://phonchi.github.io/lean-ai-learning/)

## 本機預覽

需要 Node.js 22.12 以上、npm 與 Python 3.11 以上（打包及 Lean 驗證使用 Python 標準函式庫）。

```bash
npm ci
npm run build
npm run preview
```

開發：`npm run dev`。網站在終端機顯示的本機網址開啟。

## Lean 專案

`lean-examples/` 是獨立 Lake 專案。其 `lean-toolchain`、`lakefile.toml` 與 `lake-manifest.json` 固定相容版本；安裝與練習方法見該目錄 README。網站程式碼區塊建置時直接引用這些原始檔。

```bash
npm run verify:lean
```

## 靜態託管

預設輸出 `dist/`，不需網站後端。若託管在子目錄，可在建置時指定 `BASE_PATH=/lean/`；若已有正式網域，可同時指定 `SITE_URL`。`main` 分支推送後，由 `.github/workflows/pages.yml` 自動建置並發布到 GitHub Pages。工作流程指定正式站址與 `/lean-ai-learning/` 子目錄；不建立外部帳號或啟用計費。

## 驗證紀錄

見 `verification/`。教材的解答與學生練習分開檢查；有 `sorry` 的練習骨架不作為完成證明。

## 內容與來源

教材以原創繁體中文撰寫，參考來源連結位於各章與資源頁。影片只提供原始觀看連結；不重製影片或逐字稿。字型使用自託管的 Noto Serif TC 與 JetBrains Mono，授權隨 npm 套件保留。
