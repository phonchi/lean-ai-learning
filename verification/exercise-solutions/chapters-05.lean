import Mathlib

-- 第 5 章練習 5.1 的參考解答
theorem my_sq_bound : ∀ x : ℝ, 0 ≤ x ^ 2 - 2 * x + 1 := by
  intro x
  nlinarith [sq_nonneg (x - 1)]

-- 另一種寫法：照紙上步驟拆開。
theorem my_sq_bound' : ∀ x : ℝ, 0 ≤ x ^ 2 - 2 * x + 1 := by
  intro x
  have h : x ^ 2 - 2 * x + 1 = (x - 1) ^ 2 := by ring
  rw [h]
  positivity

-- 「和 AI 一起學」範例題的可行做法（確認題目可證）。
example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ a * b + a := by
  positivity
