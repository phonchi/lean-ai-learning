import Mathlib

-- 第 1 章練習 1.1 的參考解答
theorem my_and_swap (P Q : Prop) (hp : P) (hq : Q) : Q ∧ P := by
  constructor
  · exact hq
  · exact hp

#print axioms my_and_swap
