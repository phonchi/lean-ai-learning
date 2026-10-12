import Mathlib

open Filter Topology

/-- 定理：若 aₙ → a 且 bₙ → b，則 aₙ + bₙ → a + b。 -/
theorem tendsto_add_of_tendsto (a b : ℕ → ℝ) (A B : ℝ)
    (ha : Tendsto a atTop (𝓝 A)) (hb : Tendsto b atTop (𝓝 B)) :
    Tendsto (fun n => a n + b n) atTop (𝓝 (A + B)) := by
  -- 把「收斂」改寫成 ε-N 定義：∀ ε > 0, ∃ N, ∀ n ≥ N, |xₙ - x| < ε
  rw [Metric.tendsto_atTop] at ha hb ⊢
  simp only [Real.dist_eq] at ha hb ⊢
  -- 給定 ε > 0
  intro ε hε
  -- 因為 aₙ → a，存在 N₁ 使得 n ≥ N₁ 時 |aₙ − a| < ε/2
  obtain ⟨N₁, hN₁⟩ := ha (ε / 2) (by linarith)
  -- 同理存在 N₂ 使得 n ≥ N₂ 時 |bₙ − b| < ε/2
  obtain ⟨N₂, hN₂⟩ := hb (ε / 2) (by linarith)
  -- 取 N = max(N₁, N₂)
  refine ⟨max N₁ N₂, ?_⟩
  -- 則 n ≥ N 時……
  intro n hn
  have h₁ : |a n - A| < ε / 2 := hN₁ n (le_of_max_le_left hn)
  have h₂ : |b n - B| < ε / 2 := hN₂ n (le_of_max_le_right hn)
  calc |(a n + b n) - (A + B)|
      = |(a n - A) + (b n - B)| := by ring_nf
    _ ≤ |a n - A| + |b n - B| := abs_add_le _ _
    _ < ε / 2 + ε / 2 := add_lt_add h₁ h₂
    _ = ε := by ring
