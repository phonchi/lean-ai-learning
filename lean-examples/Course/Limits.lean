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
end Course
