import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
namespace Course
-- ANCHOR: automation
-- simp 化簡已知的恆等式。
theorem automation_simp (x : ℝ) : x + 0 = x := by
  simp
-- ring 處理交換環中的多項式恆等式。
theorem automation_ring (x y : ℝ) : (x + y) ^ 2 = x ^ 2 + 2*x*y + y ^ 2 := by
  ring
-- linarith 使用前提中的線性等式與不等式。
theorem automation_linarith (x y : ℝ) (h : x ≤ y) : 2*x + 1 ≤ 2*y + 1 := by
  linarith
-- ANCHOR_END: automation
end Course
