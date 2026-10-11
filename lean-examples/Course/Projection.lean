import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
namespace Course
-- ANCHOR: projection
-- Fin 2 → ℝ 表示兩個座標；矩陣把兩個座標都換成其平均。
noncomputable def projection : Matrix (Fin 2) (Fin 2) ℝ := !![(1/2 : ℝ), 1/2; 1/2, 1/2]

theorem projection_idempotent : projection * projection = projection := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [projection, Matrix.mul_apply, Fin.sum_univ_two]

theorem projection_coordinates (v : Fin 2 → ℝ) :
    (projection.mulVec v) 0 = (projection.mulVec v) 1 := by
  simp [projection, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

theorem projection_fixed_iff (v : Fin 2 → ℝ) :
    projection.mulVec v = v ↔ v 0 = v 1 := by
  constructor
  · intro h
    have hc := projection_coordinates v
    rw [h] at hc
    exact hc
  · intro h
    ext i
    fin_cases i <;> simp [projection, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> linarith
-- ANCHOR_END: projection
end Course
