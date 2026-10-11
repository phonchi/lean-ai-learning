import Course.Squares
-- 學生練習：請用歸納法，勿直接引用正式答案。
namespace Exercises
theorem squares_zero (xs : List ℝ) : Course.squareSum xs = 0 ↔ ∀ x ∈ xs, x = 0 := by
  induction xs with
  | nil => simp [Course.squareSum]
  | cons a xs ih =>
    constructor
    · intro h
      change a ^ 2 + Course.squareSum xs = 0 at h
      have hn := Course.squares_nonneg xs
      have ha : a = 0 := by nlinarith [sq_nonneg a]
      have ht : Course.squareSum xs = 0 := by nlinarith
      intro x hx
      rcases List.mem_cons.mp hx with hxa | hxs
      · exact hxa.trans ha
      · exact ih.mp ht x hxs
    · intro h
      have ha : a = 0 := h a (by simp)
      have ht : Course.squareSum xs = 0 := ih.mpr (fun x hx => h x (by simp [hx]))
      change a ^ 2 + Course.squareSum xs = 0
      rw [ha, ht]
      norm_num
end Exercises
