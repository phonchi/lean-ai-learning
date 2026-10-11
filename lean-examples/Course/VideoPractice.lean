namespace Course

-- ANCHOR: legal-proposition
-- 命題合法不等於已有證明：這一行只查詢命題的型別。
#check ((2 : Nat) + 2 = 5)

theorem two_add_two : (2 : Nat) + 2 = 4 := rfl
-- ANCHOR_END: legal-proposition

-- ANCHOR: proof-as-function
-- 每一次函數套用都必須符合參數型別。
theorem proof_as_function (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R :=
  fun hP => hQR (hPQ hP)
-- ANCHOR_END: proof-as-function

-- ANCHOR: double-negation
-- 由 P 得到雙重否定，不需要古典推理。
theorem add_double_negation (P : Prop) (hP : P) : ¬¬P :=
  fun hNotP => hNotP hP

-- 一般命題的雙重否定消去，在此使用標準古典推理。
theorem eliminate_double_negation (P : Prop) (h : ¬¬P) : P :=
  Classical.byContradiction h
-- ANCHOR_END: double-negation

-- ANCHOR: missing-negation
-- 「對每個命題，非 P 都推出 P」不成立；取 P = False 即矛盾。
theorem missing_negation_counterexample : ¬ (∀ P : Prop, ¬P → P) := by
  intro h
  exact h False (fun hFalse => hFalse)
-- ANCHOR_END: missing-negation

end Course
