# 驗證證據

- review/final-review.md：15頁教材全文閱讀閉環、11項發現已修；最後SHA256與實際檔案吻合。
- lean/summary.json：固定Lean/mathlib v4.34.1，24項全通過；16定理僅標準公理。
- agents/*/verified-summary.json：兩組共6份proof-only候選通過編譯及公理稽核。Claude無shell，實際編譯由主代理執行，詳見agents/README.md。
- mcp/results.json：本機stdio、真實目標及sorry診斷、投影檔無診斷。
- teaching-snippets/results.json：tactic能力、名稱、兩個索引變體與預期錯誤。
- browser/results.json：16頁、4種viewport、站內連結、proof推演、提示、複製、中文搜尋、佈景、手機選單及下載；133項通過。
- site/typecheck.log與build.log：零型別錯誤，靜態建置完成。未指定正式站址時不產生sitemap；Starlight自訂404路由優先權警告不影響中文404回應。
- site/download-check.json：ZIP中20個來源與canonical逐位元組一致，無工具鏈或cache。
- sources/youtube.json：相同清單URL以HTTP200取得六支影片metadata，未取得字幕。

原始模型對話與委派context不公開；正式證據不依賴聊天或/tmp。
