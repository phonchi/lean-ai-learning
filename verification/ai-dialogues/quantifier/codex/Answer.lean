import Mathlib

-- 每個自然數 n 都有一個比它更大的自然數 m。
theorem no_largest_natural_number : ∀ n : ℕ, ∃ m : ℕ, n < m := by
  intro n
  exact ⟨n + 1, Nat.lt_succ_self n⟩
