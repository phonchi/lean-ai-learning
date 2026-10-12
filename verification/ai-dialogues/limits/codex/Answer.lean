import Mathlib

open Filter
open scoped Topology

/-- 若實數數列 aₙ → a 且 bₙ → b，則 aₙ + bₙ → a + b。 -/
theorem sequence_add_limit
    (aSeq bSeq : ℕ → ℝ) (a b : ℝ)
    (ha : Tendsto aSeq atTop (𝓝 a))
    (hb : Tendsto bSeq atTop (𝓝 b)) :
    Tendsto (fun n => aSeq n + bSeq n) atTop (𝓝 (a + b)) := by
  -- 給定 ε > 0；以 ε–N 定義證明收斂。
  apply Metric.tendsto_atTop.mpr
  intro ε hε
  have hhalf : 0 < ε / 2 := half_pos hε

  -- 因為 aₙ → a，存在 N₁，使 n ≥ N₁ 時誤差小於 ε/2。
  obtain ⟨N₁, hN₁⟩ := Metric.tendsto_atTop.mp ha (ε / 2) hhalf
  -- 同理，為 bₙ 選取 N₂。
  obtain ⟨N₂, hN₂⟩ := Metric.tendsto_atTop.mp hb (ε / 2) hhalf

  -- 取 N = max(N₁, N₂)，並考慮任意 n ≥ N。
  let N := max N₁ N₂
  refine ⟨N, ?_⟩
  intro n hn
  have hn₁ : N₁ ≤ n := le_trans (le_max_left N₁ N₂) hn
  have hn₂ : N₂ ≤ n := le_trans (le_max_right N₁ N₂) hn
  have ha_error : |aSeq n - a| < ε / 2 := by
    simpa only [Real.dist_eq] using hN₁ n hn₁
  have hb_error : |bSeq n - b| < ε / 2 := by
    simpa only [Real.dist_eq] using hN₂ n hn₂

  -- 三角不等式，再將兩個 ε/2 相加。
  rw [Real.dist_eq]
  calc
    |(aSeq n + bSeq n) - (a + b)|
        = |(aSeq n - a) + (bSeq n - b)| := by ring_nf
    _ ≤ |aSeq n - a| + |bSeq n - b| := abs_add_le _ _
    _ < ε / 2 + ε / 2 := add_lt_add ha_error hb_error
    _ = ε := by ring
