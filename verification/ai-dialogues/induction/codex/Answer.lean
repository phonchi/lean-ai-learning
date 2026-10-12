import Mathlib

-- For every positive natural number n, the sum of the first n odd numbers is n².
theorem sum_first_n_odd_numbers (n : ℕ) (_hn : 0 < n) :
    (∑ k ∈ Finset.range n, (2 * k + 1)) = n ^ 2 := by
  -- Including n = 0 gives a convenient induction with an empty-sum base case.
  have h : ∀ m : ℕ, (∑ k ∈ Finset.range m, (2 * k + 1)) = m ^ 2 := by
    intro m
    induction m with
    | zero => simp
    | succ m ih =>
        rw [Finset.sum_range_succ, ih]
        ring
  exact h n
