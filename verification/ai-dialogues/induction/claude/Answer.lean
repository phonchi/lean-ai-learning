import Mathlib

open Finset

/-- 定理：對每個正整數 n，1 + 3 + 5 + ⋯ + (2n − 1) = n²。
左邊寫成 ∑_{i=1}^{n} (2i − 1)。 -/
theorem sum_odd (n : ℕ) (hn : 1 ≤ n) :
    ∑ i ∈ Icc 1 n, (2 * i - 1) = n ^ 2 := by
  -- 從 n = 1 開始的數學歸納法
  induction n, hn using Nat.le_induction with
  | base =>
    -- n = 1：左邊是 1，右邊是 1
    simp
  | succ n hn ih =>
    -- 歸納步驟：把第 n+1 項 2(n+1) − 1 拆出來，再用歸納假設
    rw [sum_Icc_succ_top (by omega), ih]
    -- n² + (2(n+1) − 1) = n² + 2n + 1 = (n+1)²
    have h : 2 * (n + 1) - 1 = 2 * n + 1 := by omega
    rw [h]
    ring
