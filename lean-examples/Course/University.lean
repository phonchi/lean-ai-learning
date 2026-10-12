import Mathlib.Basic.Real.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
namespace Course

-- ANCHOR: uni-and-intro
-- 離散數學：已知 P 且已知 Q，所以 P ∧ Q。
theorem uni_and_intro (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp
  · exact hq
-- ANCHOR_END: uni-and-intro

-- ANCHOR: uni-or-swap
-- 分情況：P 成立或 Q 成立，兩種情況都要推出 Q ∨ P。
theorem uni_or_swap (P Q : Prop) : P ∨ Q → Q ∨ P := by
  intro h
  rcases h with hp | hq
  · right
    exact hp
  · left
    exact hq
-- ANCHOR_END: uni-or-swap

-- ANCHOR: uni-contrapositive
-- 逆否：若 P 推出 Q，且 Q 不成立，則 P 不成立。
theorem uni_contrapositive (P Q : Prop) : (P → Q) → ¬ Q → ¬ P := by
  intro hpq hnq hp
  exact hnq (hpq hp)
-- ANCHOR_END: uni-contrapositive

-- ANCHOR: uni-no-largest
-- 對每個自然數 n，都有比它大的 m：取 m = n + 1。
theorem uni_no_largest : ∀ n : ℕ, ∃ m : ℕ, n < m := by
  intro n
  exact ⟨n + 1, Nat.lt_succ_self n⟩
-- ANCHOR_END: uni-no-largest

-- ANCHOR: uni-square-lower-bound
-- 存在一個實數 x，使得每個 y 的平方都不小於 x：取 x = 0。
theorem uni_square_lower_bound : ∃ x : ℝ, ∀ y : ℝ, x ≤ y ^ 2 := by
  refine ⟨0, ?_⟩
  intro y
  exact sq_nonneg y
-- ANCHOR_END: uni-square-lower-bound

-- ANCHOR: uni-gauss
-- 高斯求和的兩倍形式：0 + 1 + ⋯ + n 的兩倍等於 n(n+1)。
-- 寫成兩倍是為了避開自然數除法。
theorem uni_gauss (n : ℕ) : 2 * ∑ i ∈ Finset.range (n + 1), i = n * (n + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add, ih]
    ring
-- ANCHOR_END: uni-gauss

-- ANCHOR: uni-two-xy
-- 微積分常用不等式：2xy ≤ x² + y²，因為 (x - y)² ≥ 0。
theorem uni_two_xy (x y : ℝ) : 2 * x * y ≤ x ^ 2 + y ^ 2 := by
  nlinarith [sq_nonneg (x - y)]
-- ANCHOR_END: uni-two-xy

-- ANCHOR: uni-positivity
-- positivity 會檢查每一項都是正的或非負的。
theorem uni_positivity (x : ℝ) (h : 0 < x) : 0 < x ^ 2 + x := by
  positivity
-- ANCHOR_END: uni-positivity

end Course
