import Mathlib

-- 第 2 章練習 2.1 的參考解答
theorem my_imp_and (P Q R : Prop) (hpq : P → Q) (hpr : P → R) : P → Q ∧ R :=
  fun hp => ⟨hpq hp, hpr hp⟩
