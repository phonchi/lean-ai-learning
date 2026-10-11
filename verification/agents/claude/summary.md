# 三實戰 agent 驗證摘要（Claude）

## 重要：本次未實際編譯

這個 session 沒有任何可執行 shell 的工具（只有讀、寫、搜尋檔案），所以**未執行**指定的指令：

```bash
ELAN_HOME=/home/phonchi/lean/.tools/elan /home/phonchi/lean/.tools/elan/bin/lake env lean Exercises/ProofRepair.lean
ELAN_HOME=/home/phonchi/lean/.tools/elan /home/phonchi/lean/.tools/elan/bin/lake env lean Exercises/OddSum.lean
ELAN_HOME=/home/phonchi/lean/.tools/elan /home/phonchi/lean/.tools/elan/bin/lake env lean Exercises/Squares.lean
```

因此：
- 沒有任何編譯輸出，所以本目錄**沒有**驗證 log 檔。我沒有建立任何偽造的 log。
- exit code：**未知（未執行）**。
- 三題都**不能**宣稱已通過。目前只是「已寫入 proof body，等待編譯」。
- 編譯修復輪數：每檔 0 輪（未編譯，所以沒有修復迴圈）。

請在工作目錄 `/home/phonchi/lean/verification/agents/claude` 執行上面三行指令，把完整輸出存成 `Exercises/` 同層的 log（例如 `ProofRepair.log`），再依結果更新本檔。

## 修改範圍

只把三檔中的 `sorry` 換成 proof body；import、statement、定義、namespace 都沒有更動，沒有新增 `axiom`、`sorry`、`admit`，也沒有引用 `Course.imp_trans`、`Course.odd_sum`、`Course.squares_zero`。

| 檔案 | 寫入的證明 | 使用的外部名稱（已在本機原始碼核對存在） |
| --- | --- | --- |
| `Exercises/ProofRepair.lean` | `intro hP`、`apply hQR`、`apply hPQ`、`exact hP` | 無（純核心 tactic，檔案沒有 import） |
| `Exercises/OddSum.lean` | 對 `n` 歸納；`zero` 用 `simp`；`succ` 用 `rw [Finset.sum_range_succ, ih]` 後 `ring` | `Finset.sum_range_succ` |
| `Exercises/Squares.lean` | 對 `xs` 歸納；`nil` 用 `simp [Course.squareSum]`；`cons` 先用 `rfl` 展開 `squareSum (x :: xs) = x ^ 2 + squareSum xs`，`simp only [List.forall_mem_cons]`，再分兩方向：用 `linarith`（搭配 `Course.squares_nonneg xs` 與 `sq_nonneg x`）得到 `x ^ 2 = 0` 與尾端和為 0，再用 `sq_eq_zero_iff` 與 `ih`；反方向 `rw` 後 `norm_num` | `Course.squareSum`、`Course.squares_nonneg`、`sq_nonneg`、`sq_eq_zero_iff`（`Mathlib/Algebra/GroupWithZero/Basic.lean`）、`List.forall_mem_cons`（Lean 核心 `Init/Data/List/Lemmas.lean`） |

## 靜態審查時發現的風險點（編譯時優先看）

1. Squares：`have hsum : ... := rfl` 依賴 `List.map` 與 `List.sum` 在 cons 上可以定義展開。`Course/Squares.lean` 用同樣的 `change` 成功編譯才可推論可行；若失敗，改成 `by simp [Course.squareSum]`。
2. Squares：`simp only [List.forall_mem_cons]` 要能比對到 `∀ x ∈ x :: xs, x = 0` 的 binder 形式。若顯示沒有進展，改用 `List.mem_cons, forall_eq_or_imp`（canonical 的做法）。
3. Squares：`linarith` 證明等式目標時，會拆成兩個不等式；這裡的原子是 `x ^ 2` 與 `Course.squareSum xs`，兩者的非負性都已提供。

## 學習重點（給教材的回饋）

- ProofRepair 只有一個 `sorry`，用 `apply` 倒推最能對應第 3 章的「逐行觀察 apply」說明。
- OddSum 的主題和 `Course.odd_sum` 同型，三步節奏（拆、代、整理）可以直接套用。
- Squares 的關鍵在於「非負項之和為零」；有了 `Course.squares_nonneg` 這個輔助引理，歸納步驟只剩線性推理，不需要 `nlinarith`。
- agent 在沒有編譯工具時，只能交出「未驗證的候選證明」。這正好示範了教材的原則：沒有實際輸出，就不能稱為完成。
