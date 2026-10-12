我把這句話寫成 Lean 4 定理並完成證明，結果放在 `Answer.lean`。執行 `lake env lean Answer.lean` 通過，沒有錯誤或警告，也沒有用到 `sorry`。

```lean
import Mathlib

theorem no_largest_nat : ¬ ∃ n : ℕ, ∀ m : ℕ, m ≤ n := by
  rintro ⟨n, hn⟩
  have h := hn (n + 1)
  omega

theorem exists_larger_nat : ∀ n : ℕ, ∃ m : ℕ, n < m :=
  fun n => ⟨n + 1, Nat.lt_succ_self n⟩
```

## 這個陳述在數學上說了什麼

**主定理 `no_largest_nat`：** `¬ ∃ n : ℕ, ∀ m : ℕ, m ≤ n`

用數學式子寫是 ¬(∃n ∈ ℕ, ∀m ∈ ℕ, m ≤ n)，意思是：**不存在**一個自然數 n，使得**所有**自然數 m 都小於或等於 n。

- 「n 是最大的自然數」寫成「∀m, m ≤ n」，也就是每個自然數都不超過 n。
- 「沒有最大的」就是在前面加上「¬∃」，表示找不到這樣的 n。
- 證明用反證法：假設這樣的 n 存在，把 m 代成 n + 1，會得到 n + 1 ≤ n，這不可能成立。最後一步的算術矛盾交給 `omega` 自動處理。

**附帶的等價說法 `exists_larger_nat`：** `∀ n : ℕ, ∃ m : ℕ, n < m`

意思是：對每個自然數 n，都找得到比它大的自然數 m（例如 m = n + 1）。

這兩個定理之間的關係，正是離散數學裡的量詞否定規則：

¬∃n ∀m (m ≤ n) ⟺ ∀n ∃m ¬(m ≤ n) ⟺ ∀n ∃m (n < m)

可以注意兩點：

- 量詞的順序很重要。「∀n ∃m, n < m」是對的，因為 m 可以隨 n 改變。如果把順序對調成「∃m ∀n, n < m」，意思就變成「有一個自然數比所有自然數都大」，這是錯的。
- 在 Lean 和 mathlib 裡，`ℕ` 包含 0。不過這不影響這句話是否成立。