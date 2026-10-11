import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring
namespace Course
-- ANCHOR: odd-sum
-- range n 的索引是 0 到 n - 1；第 k 項是 2*k+1。
theorem odd_sum (n : ℕ) : ∑ k ∈ Finset.range n, (2 * k + 1) = n ^ 2 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    ring
-- ANCHOR_END: odd-sum
end Course
