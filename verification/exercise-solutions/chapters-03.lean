import Mathlib

-- 第 3 章練習 3.1 的參考解答
example : ∀ x : ℝ, ∃ y : ℝ, x < y := by
  intro x
  exact ⟨x + 1, by linarith⟩
