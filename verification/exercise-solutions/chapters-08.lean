import Mathlib

-- 練習 8.1 參考解答：「對所有實數 x，若 x 大於 0，則 x 加上 x 的倒數至少為 2」的忠實翻譯。
theorem add_inv_ge_two (x : ℝ) (hx : 0 < x) : 2 ≤ x + 1 / x := by
  have key : x + 1 / x - 2 = (x - 1) ^ 2 / x := by
    field_simp
    ring
  have h : 0 ≤ (x - 1) ^ 2 / x := by positivity
  linarith

-- 檢查翻譯用的小例子：在 ℕ 中 1 / 2 是 0，(a) 的意義已經不同。
example : (1 : ℕ) / 2 = 0 := by norm_num

-- (b) 缺少正數假設時陳述為假：x = -1 是反例。
example : ¬ ∀ x : ℝ, 2 ≤ x + 1 / x := by
  intro h
  have := h (-1)
  norm_num at this
