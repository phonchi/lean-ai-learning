import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring
-- 學生練習：索引從 0 起算，共 n 項。
namespace Exercises
theorem odd_sum (n : ℕ) : ∑ k ∈ Finset.range n, (2 * k + 1) = n ^ 2 := by
  induction n with
  | zero => simp
  | succ k hk =>
    rw [Finset.sum_range_succ, hk]
    ring
end Exercises
