import Mathlib

-- 第 4 章練習 4.1 的參考解答：2^0 + ⋯ + 2^n = 2^(n+1) - 1，改寫成不含減法的等價形式
example (n : ℕ) : (∑ i ∈ Finset.range (n + 1), 2 ^ i) + 1 = 2 ^ (n + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, add_right_comm, ih]
    ring
