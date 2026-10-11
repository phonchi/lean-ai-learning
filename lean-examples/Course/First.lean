namespace Course
-- ANCHOR: first-proof
-- 目標是把已知的 h 原封不動交回。
theorem first_proof (P : Prop) (h : P) : P := by
  exact h
-- ANCHOR_END: first-proof
-- ANCHOR: first-term
-- 同一個證明也可以直接寫成函數。
theorem first_term (P : Prop) : P → P := fun h => h
-- ANCHOR_END: first-term
-- ANCHOR: first-check
-- #check 顯示型別；#print axioms 顯示證明的公理依賴。
#check first_proof
#print axioms first_proof
-- ANCHOR_END: first-check
end Course
