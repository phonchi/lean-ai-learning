import Mathlib.Basic.Real.Basic
import Mathlib.Algebra.BigOperators.Group.List.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
namespace Course
-- ANCHOR: squares-nonneg
-- 列表保留重複元素；空列表的平方和定義為 0。
def squareSum (xs : List ℝ) : ℝ := (xs.map (fun x => x ^ 2)).sum

theorem squares_nonneg (xs : List ℝ) : 0 ≤ squareSum xs := by
  induction xs with
  | nil => simp [squareSum]
  | cons x xs ih =>
    change 0 ≤ x ^ 2 + squareSum xs
    exact add_nonneg (sq_nonneg x) ih
-- ANCHOR_END: squares-nonneg
-- ANCHOR: squares-zero
theorem squares_zero (xs : List ℝ) : squareSum xs = 0 ↔ ∀ x ∈ xs, x = 0 := by
  induction xs with
  | nil => simp [squareSum]
  | cons x xs ih =>
    constructor
    · intro h
      change x ^ 2 + squareSum xs = 0 at h
      have hs := squares_nonneg xs
      have hx : x = 0 := by nlinarith [sq_nonneg x]
      have ht : squareSum xs = 0 := by nlinarith
      simpa only [List.mem_cons, forall_eq_or_imp] using And.intro hx (ih.mp ht)
    · intro h
      have hx : x = 0 := h x (by simp)
      have ht : squareSum xs = 0 := ih.mpr (fun y hy => h y (by simp [hy]))
      change x ^ 2 + squareSum xs = 0
      rw [hx, ht]
      norm_num
-- ANCHOR_END: squares-zero
end Course
