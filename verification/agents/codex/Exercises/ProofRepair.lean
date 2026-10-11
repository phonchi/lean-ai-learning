-- 學生練習：只填寫證明，保留命題與前提。
namespace Exercises
theorem imp_trans (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hp
  apply hQR
  exact hPQ hp
end Exercises
