已寫好 `Answer.lean`，`lake env lean Answer.lean` 檢查通過，沒有錯誤也沒有警告。

## Lean 證明

```lean
import Mathlib

open Filter Topology

theorem tendsto_add_of_tendsto (a b : ℕ → ℝ) (A B : ℝ)
    (ha : Tendsto a atTop (𝓝 A)) (hb : Tendsto b atTop (𝓝 B)) :
    Tendsto (fun n => a n + b n) atTop (𝓝 (A + B)) := by
  rw [Metric.tendsto_atTop] at ha hb ⊢
  simp only [Real.dist_eq] at ha hb ⊢
  intro ε hε
  obtain ⟨N₁, hN₁⟩ := ha (ε / 2) (by linarith)
  obtain ⟨N₂, hN₂⟩ := hb (ε / 2) (by linarith)
  refine ⟨max N₁ N₂, ?_⟩
  intro n hn
  have h₁ : |a n - A| < ε / 2 := hN₁ n (le_of_max_le_left hn)
  have h₂ : |b n - B| < ε / 2 := hN₂ n (le_of_max_le_right hn)
  calc |(a n + b n) - (A + B)|
      = |(a n - A) + (b n - B)| := by ring_nf
    _ ≤ |a n - A| + |b n - B| := abs_add_le _ _
    _ < ε / 2 + ε / 2 := add_lt_add h₁ h₂
    _ = ε := by ring
```

數列寫成函數 `a b : ℕ → ℝ`。課本的極限 `a`、`b` 在這裡改用大寫 `A`、`B`，以免和數列同名。

## 每一步對應課本哪一句

| Lean | 課本 |
|---|---|
| 定理敘述 `Tendsto a atTop (𝓝 A)` 等 | 「若 aₙ → a 且 bₙ → b，則 aₙ + bₙ → a + b」。mathlib 用 `Tendsto ... atTop (𝓝 A)` 表示「n → ∞ 時 aₙ → A」。 |
| `rw [Metric.tendsto_atTop]`、`simp only [Real.dist_eq]` | 課本沒寫出這句，但它默認用 ε-N 定義。這兩行把 mathlib 的抽象定義展開成 `∀ ε > 0, ∃ N, ∀ n ≥ N, |xₙ − x| < ε`，展開後才能照課本的步驟證。 |
| `intro ε hε` | 「給定 ε > 0」。`hε` 就是 `0 < ε` 這個前提。 |
| `obtain ⟨N₁, hN₁⟩ := ha (ε / 2) (by linarith)` | 「因為 aₙ → a，存在 N₁ 使得 n ≥ N₁ 時 \|aₙ − a\| < ε/2」。把 ε/2 代入 aₙ 收斂的定義，`by linarith` 負責證明 ε/2 > 0。 |
| `obtain ⟨N₂, hN₂⟩ := hb (ε / 2) ...` | 「同理存在 N₂ 使得 n ≥ N₂ 時 \|bₙ − b\| < ε/2」 |
| `refine ⟨max N₁ N₂, ?_⟩` | 「取 N = max(N₁, N₂)」 |
| `intro n hn` | 「則 n ≥ N 時」。`hn : n ≥ max N₁ N₂`。 |
| `have h₁ ...`、`have h₂ ...` | 課本這裡省略沒寫：n ≥ max(N₁, N₂) 推得 n ≥ N₁ 和 n ≥ N₂，所以兩個 ε/2 的估計都成立。Lean 要求寫出這一步，用的是 `le_of_max_le_left/right`。 |
| `calc` 第一行 `= \|(aₙ−A)+(bₙ−B)\|`（`ring_nf`） | 把 (aₙ + bₙ) − (a + b) 重排成 (aₙ − a) + (bₙ − b)。課本直接跳過這步。 |
| `_ ≤ \|aₙ−A\| + \|bₙ−B\|`（`abs_add_le`） | 課本的「≤ \|aₙ − a\| + \|bₙ − b\|」，也就是三角不等式 |
| `_ < ε/2 + ε/2`（`add_lt_add h₁ h₂`） | 課本的「< ε/2 + ε/2」，把上面兩個估計相加 |
| `_ = ε`（`ring`） | 課本的「= ε」，到這裡證完 |

補充一點：mathlib 本來就有這個定理，叫 `Filter.Tendsto.add`，一行 `ha.add hb` 就能證完。這裡刻意不用它，而是照課本的 ε-N 步驟逐句寫出來。