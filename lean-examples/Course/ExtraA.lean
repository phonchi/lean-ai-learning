import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum
namespace Course

-- ANCHOR: extra-types
-- 程式世界：值有型別，函數也有型別。
#check (3 : ℕ)
#check fun (n : ℕ) => n + 1
-- ANCHOR_END: extra-types

-- ANCHOR: extra-id
-- 「P 推出 P」的證明就是恆等函數。
theorem extra_id (P : Prop) : P → P := fun hp => hp
-- ANCHOR_END: extra-id

-- ANCHOR: extra-const
-- 收到 P 的證明與 Q 的證明，交回 P 的證明；第二個參數用不到。
theorem extra_const (P Q : Prop) : P → Q → P := fun hp _ => hp
-- ANCHOR_END: extra-const

-- ANCHOR: extra-and-pair
-- 「且」的證明是一對證明。
theorem extra_and_pair (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := ⟨hp, hq⟩

-- 拿到一對之後，.1 與 .2 分別取出兩個分量，再交換順序配成新的一對。
theorem extra_and_swap_term (P Q : Prop) : P ∧ Q → Q ∧ P := fun h => ⟨h.2, h.1⟩
-- ANCHOR_END: extra-and-pair

-- ANCHOR: extra-two-xy-steps
-- 把 2xy ≤ x² + y² 照紙上的步驟拆開寫。
theorem extra_two_xy_steps (x y : ℝ) : 2 * x * y ≤ x ^ 2 + y ^ 2 := by
  have h : 0 ≤ (x - y) ^ 2 := sq_nonneg (x - y)
  have expand : (x - y) ^ 2 = x ^ 2 - 2 * x * y + y ^ 2 := by ring
  rw [expand] at h
  linarith
-- ANCHOR_END: extra-two-xy-steps

-- ANCHOR: extra-choose-tool
-- 等式：交換環恆等式，用 ring。
theorem extra_choose_ring (a b : ℝ) : (a - b) * (a + b) = a ^ 2 - b ^ 2 := by
  ring
-- 線性不等式：由兩個假設串起來，用 linarith。
theorem extra_choose_linarith (x y : ℝ) (h1 : x ≤ y) (h2 : y ≤ 3) : x ≤ 3 := by
  linarith
-- 正性：平方加正數，用 positivity。
theorem extra_choose_positivity (x : ℝ) : 0 ≤ x ^ 2 + 1 := by
  positivity
-- ANCHOR_END: extra-choose-tool

-- ANCHOR: extra-find-lemma
-- 猜名字之後先 #check，再實際用它。
#check add_nonneg
theorem extra_find_lemma (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ a + b := by
  exact add_nonneg ha hb
-- ANCHOR_END: extra-find-lemma

-- ANCHOR: extra-use-hypothesis
-- ring 不看假設：先用 rw 把 x 換成 2，再讓 norm_num 計算。
theorem extra_use_hypothesis (x : ℝ) (h : x = 2) : x ^ 2 = 4 := by
  rw [h]
  norm_num
-- ANCHOR_END: extra-use-hypothesis

end Course
