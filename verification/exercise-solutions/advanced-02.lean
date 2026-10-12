import Mathlib
import Course.Projection

-- 進階 2 練習 A2.1 的參考解答：P 的像恰好是直線 y = x
theorem projection_range :
    Set.range Course.projection.mulVec = {v : Fin 2 → ℝ | v 0 = v 1} := by
  ext v
  constructor
  · rintro ⟨w, rfl⟩
    exact Course.projection_coordinates w
  · intro h
    exact ⟨v, (Course.projection_fixed_iff v).mpr h⟩
