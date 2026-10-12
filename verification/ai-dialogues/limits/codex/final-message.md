已寫入 [Answer.lean](<scratch>/Answer.lean)，並以 `lake env lean Answer.lean` 檢查通過，無錯誤或警告。數列採用實數型別 `ℕ → ℝ`。

Lean 證明與課本的對應如下：

| Lean 步驟 | 課本證明 |
|---|---|
| `Metric.tendsto_atTop.mpr` | 將收斂目標改寫成 ε–N 定義。 |
| `intro ε hε` | 「給定 ε > 0。」 |
| `have hhalf ... := half_pos hε` | 確認 ε/2 > 0，可以套用收斂假設。 |
| `obtain ⟨N₁, hN₁⟩ ...` | 「因為 aₙ → a，存在 N₁……誤差小於 ε/2。」 |
| `obtain ⟨N₂, hN₂⟩ ...` | 「同理存在 N₂……。」 |
| `let N := max N₁ N₂` | 「取 N = max(N₁, N₂)。」 |
| `intro n hn` 與 `hn₁`、`hn₂` | 任取 n ≥ N，推出 n ≥ N₁ 且 n ≥ N₂。 |
| `ha_error`、`hb_error` | 得到兩個絕對值誤差都小於 ε/2；`Real.dist_eq` 把實數距離換成絕對值。 |
| `calc` 第一行、`ring_nf` | 將總誤差改寫為 `(aₙ − a) + (bₙ − b)` 的絕對值。 |
| `abs_add_le` | 使用三角不等式。 |
| `add_lt_add ha_error hb_error` | 兩個誤差相加，小於 ε/2 + ε/2。 |
| 最後的 `ring` | 證明 ε/2 + ε/2 = ε，完成證明。 |

其中 `Tendsto aSeq atTop (𝓝 a)` 就是 mathlib 表示「aₙ → a」的方式。