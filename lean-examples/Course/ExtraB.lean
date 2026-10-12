import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FinCases
namespace Course
-- ANCHOR: extrab-n3-table
-- n = 3 時三種索引範圍的實際值，用 decide 讓 Lean 直接算。
example : ∑ i ∈ Finset.range 3, (2 * i + 1) = 9 := by decide
example : ∑ i ∈ Finset.range (3 + 1), (2 * i + 1) = 16 := by decide
example : ∑ i ∈ Finset.Icc 1 3, (2 * i - 1) = 9 := by decide
-- 高斯公式的錯誤翻譯：range 3 只有 0、1、2，和是 3，不是 6。
example : ¬ (∑ i ∈ Finset.range 3, i = 3 * (3 + 1) / 2) := by decide
-- ANCHOR_END: extrab-n3-table

-- ANCHOR: extrab-index-bridge
-- 兩種寫法對每個 n 都相等：Icc 1 n 配 2i - 1，range n 配 2k + 1。
theorem extrab_icc_eq_range (n : ℕ) :
    ∑ i ∈ Finset.Icc 1 n, (2 * i - 1) = ∑ k ∈ Finset.range n, (2 * k + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_Icc_succ_top (by omega), Finset.sum_range_succ, ih]
    omega
-- ANCHOR_END: extrab-index-bridge

-- ANCHOR: extrab-proj-apply
-- 紙上算出 P (3, 1) = (2, 2)；這裡把同一個矩陣直接寫出來。
example : !![(1/2 : ℝ), 1/2; 1/2, 1/2].mulVec ![3, 1] = ![2, 2] := by
  ext i
  fin_cases i <;> norm_num [Matrix.mulVec, dotProduct, Fin.sum_univ_two]
-- ANCHOR_END: extrab-proj-apply

-- ANCHOR: extrab-proj-kernel
-- 核空間：P v = 0 若且唯若 v₀ + v₁ = 0，也就是直線 y = -x。
theorem extrab_proj_kernel (v : Fin 2 → ℝ) :
    !![(1/2 : ℝ), 1/2; 1/2, 1/2].mulVec v = 0 ↔ v 0 + v 1 = 0 := by
  constructor
  · intro h
    have h0 := congrFun h 0
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h0
    linarith
  · intro h
    ext i
    fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> linarith
-- ANCHOR_END: extrab-proj-kernel

-- ANCHOR: extrab-nat-trap
-- 型別寫成 ℕ 時，1/2 = 0，整個矩陣就是零矩陣。
example : !![(1/2 : ℕ), 1/2; 1/2, 1/2] = 0 := by decide
-- ANCHOR_END: extrab-nat-trap
end Course
