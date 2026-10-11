-- 預期失敗：只有 P → Q，並不足以證明 Q → P。
example (P Q : Prop) (h : P → Q) : Q → P := by
  exact h
