import Mathlib.Topology.Algebra.Ring.Real
namespace Course
open Filter Topology
-- ANCHOR: limits-add
-- u、v 是 ℕ → ℝ 的序列；atTop 表示索引趨向無窮。
-- 𝓝 a 是 a 的鄰域濾子，Tendsto u atTop (𝓝 a) 表示 u 收斂到 a。
theorem limits_add (u v : ℕ → ℝ) (a b : ℝ)
    (hu : Tendsto u atTop (𝓝 a)) (hv : Tendsto v atTop (𝓝 b)) :
    Tendsto (fun n => u n + v n) atTop (𝓝 (a + b)) := by
  exact hu.add hv
-- ANCHOR_END: limits-add
-- ANCHOR: limits-eps-bridge
-- 把 mathlib 的 Tendsto 寫回課本的 ε-N 定義：兩者等價。
theorem tendsto_iff_eps (u : ℕ → ℝ) (a : ℝ) :
    Tendsto u atTop (𝓝 a) ↔ ∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - a| < ε := by
  simp [Metric.tendsto_atTop, Real.dist_eq]
-- ANCHOR_END: limits-eps-bridge

-- ANCHOR: limits-add-eps
-- 課本證明：各取 ε/2，再取 N = max N₁ N₂，最後用三角不等式。
theorem limits_add_eps (u v : ℕ → ℝ) (a b : ℝ)
    (hu : ∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - a| < ε)
    (hv : ∀ ε > 0, ∃ N, ∀ n ≥ N, |v n - b| < ε) :
    ∀ ε > 0, ∃ N, ∀ n ≥ N, |(u n + v n) - (a + b)| < ε := by
  intro ε hε
  obtain ⟨N₁, hN₁⟩ := hu (ε / 2) (by linarith)
  obtain ⟨N₂, hN₂⟩ := hv (ε / 2) (by linarith)
  refine ⟨max N₁ N₂, ?_⟩
  intro n hn
  have h1 : |u n - a| < ε / 2 := hN₁ n (le_of_max_le_left hn)
  have h2 : |v n - b| < ε / 2 := hN₂ n (le_of_max_le_right hn)
  calc |(u n + v n) - (a + b)| = |(u n - a) + (v n - b)| := by ring_nf
    _ ≤ |u n - a| + |v n - b| := abs_add_le _ _
    _ < ε / 2 + ε / 2 := by linarith
    _ = ε := by ring
-- ANCHOR_END: limits-add-eps
end Course
