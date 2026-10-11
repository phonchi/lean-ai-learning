namespace Course
-- ANCHOR: imp-trans
theorem imp_trans (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  exact hQR (hPQ hP)
-- ANCHOR_END: imp-trans
-- ANCHOR: imp-trans-steps
-- 每次 apply 都把目前目標換成所用蘊涵的前提。
theorem imp_trans_steps (P Q R : Prop) (hpq : P → Q) (hqr : Q → R) : P → R := by
  intro hp
  apply hqr
  apply hpq
  exact hp
-- ANCHOR_END: imp-trans-steps
-- ANCHOR: and-swap
theorem and_swap (P Q : Prop) : P ∧ Q → Q ∧ P := by
  intro h
  exact ⟨h.2, h.1⟩
-- ANCHOR_END: and-swap
-- ANCHOR: quantifiers
-- 「每個 x 都符合 P」可以套用到指定的 a。
theorem quantifiers {α : Type} (P : α → Prop) (h : ∀ x, P x) (a : α) : P a := by
  exact h a
-- ANCHOR_END: quantifiers
end Course
