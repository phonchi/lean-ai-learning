已寫入 [Answer.lean](<scratch>/Answer.lean)，並通過 `lake env lean Answer.lean`，無錯誤或警告。

Lean 的定理陳述與課本**數學意義完全一致**：`n : ℕ` 加上 `0 < n` 表示正整數，而
```lean
∑ k ∈ Finset.range n, (2 * k + 1)
```
依序加總 `1, 3, …, 2n−1`。

證明同樣使用數學歸納法，但從 `n = 0` 的空和開始，先證明所有自然數都成立，再套用到正整數。這與課本從 `n = 1` 開始的證明略有不同；歸納步驟的計算相同。