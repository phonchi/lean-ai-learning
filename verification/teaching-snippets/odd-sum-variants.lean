import Course.Induction
import Mathlib.Algebra.BigOperators.Intervals
theorem odd_sum_succ_check (n : ℕ) : ∑ k ∈ Finset.range (n + 1), (2 * k + 1) = (n + 1) ^ 2 := by
  exact Course.odd_sum (n + 1)
theorem odd_sum_Icc_check (n : ℕ) : ∑ k ∈ Finset.Icc 1 n, (2 * k - 1) = n ^ 2 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih]
    have h : 2 * (n + 1) - 1 = 2 * n + 1 := by omega
    rw [h]
    ring
