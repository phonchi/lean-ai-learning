import Mathlib

/-- 「沒有最大的自然數」：不存在一個自然數 `n`，使得每個自然數 `m` 都滿足 `m ≤ n`。 -/
theorem no_largest_nat : ¬ ∃ n : ℕ, ∀ m : ℕ, m ≤ n := by
  rintro ⟨n, hn⟩
  -- 若 `n` 是最大的，則 `n + 1 ≤ n`，矛盾。
  have h := hn (n + 1)
  omega

/-- 等價的正面說法：對每個自然數 `n`，都存在比它更大的自然數 `m`。 -/
theorem exists_larger_nat : ∀ n : ℕ, ∃ m : ℕ, n < m :=
  fun n => ⟨n + 1, Nat.lt_succ_self n⟩
