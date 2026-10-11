import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Basic.Real.Basic
example (a b : ℝ) : (a-b)*(a+b)=a^2-b^2 := by linarith
example (x : ℝ) (h : 0 ≤ x) : 0 ≤ x + 1 := by positivity
