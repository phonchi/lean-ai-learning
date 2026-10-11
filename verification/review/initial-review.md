# 首輪全文審閱

閱讀者：Astra（相對於Claude教材作者獨立；先前參與canonical Lean程式）。全程唯讀。15頁教材全文、7正式Lean檔、3練習、2負例、4元件及首頁皆已讀完。讀取版本見 initial-reading-hashes.json。這是修正前快照，不能當最後版本通過。

## 必須修正

1. ch06/ch08/lab03/setup以lake build驗收Exercises，實際不在defaultTargets。逐檔lake env lean才會檢查練習。
2. lab02稱檔案已有range(n+1)/Icc變體，實際只有主題；應明列新增選做題。
3. ch06/ch07要求同檔另一個sorry，實際只有一題；lab03非負題應說明是已提供的輔助引理。
4. ch05錯稱linarith不能證平方差、positivity不能利用局部非負假設；固定版本stdin實測兩者均可。
5. projection頁Matrix.dotProduct不存在，正確為全域dotProduct。
6. ch03說明apply卻引用exact版本，應使用imp-trans-steps。
7. ch06 echo API key會顯示憑證，應只印設定狀態。
8. ch06不能保證所有CLI預設逐次詢問；初學逐步審核改用只提建議、學生手動貼入。
9. projection應橋接固定點與像空間反向包含。
10. unknown identifier應先查imports/namespace/完整名稱。
11. ch04不應說只有歸納能涵蓋所有n。

## 已確認

奇數和索引/空和、高斯練習、平方和空列表與重複值、極限epsilon/2及Tendsto.add、投影數學推理、sorry與標準公理、canonical regions、首頁proof states皆確認無誤。YouTube完整相同URL由主代理HTTP200核對，未取得字幕、未宣稱觀看影片，無不實新聞引用。

少量教學片段編譯由閱讀者使用lean --stdin執行；主代理另保存可重跑片段檢查。最終修正版仍須重讀。
