import Mathlib

-- 進階 1 練習 A1.1 的參考解答：常數倍（ε-N 形式）
example (u : ℕ → ℝ) (a c : ℝ) (hu : ∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - a| < ε) :
    ∀ ε > 0, ∃ N, ∀ n ≥ N, |c * u n - c * a| < ε := by
  intro ε hε
  have hc : 0 < |c| + 1 := by positivity
  obtain ⟨N, hN⟩ := hu (ε / (|c| + 1)) (by positivity)
  refine ⟨N, ?_⟩
  intro n hn
  have h := hN n hn
  calc |c * u n - c * a| = |c| * |u n - a| := by rw [← mul_sub, abs_mul]
    _ ≤ |c| * (ε / (|c| + 1)) := by gcongr
    _ < (|c| + 1) * (ε / (|c| + 1)) := by gcongr; linarith
    _ = ε := by field_simp

-- 同一個定理的 Tendsto 版本：mathlib 已有 Filter.Tendsto.const_mul
example (u : ℕ → ℝ) (a c : ℝ) (hu : Filter.Tendsto u Filter.atTop (nhds a)) :
    Filter.Tendsto (fun n => c * u n) Filter.atTop (nhds (c * a)) :=
  hu.const_mul c
