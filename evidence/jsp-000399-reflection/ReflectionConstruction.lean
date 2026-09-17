import Std

/-!
Explicit positive-integer inputs for the known reflection/complement
obstruction in JSP-000399 / Erdos 494, for every subset size k >= 2.
Only Lean's standard library is used.
-/

namespace JSP399General

def sourceValues (k : Nat) : List Nat :=
  (List.range (2*k-1)).map (fun i => k+i) ++ [4*k-1]

def reflectionValues (k : Nat) : List Nat :=
  (sourceValues k).map (fun x => 4*k-x)

private theorem nat_sum_append (xs ys : List Nat) :
    (xs ++ ys).sum = xs.sum + ys.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Nat.add_assoc]

private theorem shifted_sum (a : Nat) (xs : List Nat) :
    (xs.map (fun x => a+x)).sum = xs.length*a + xs.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    simp only [List.map_cons, List.sum_cons, List.length_cons, ih, Nat.add_mul,
      Nat.one_mul]
    omega

private theorem twice_range_sum (n : Nat) :
    2*(List.range n).sum+n = n*n := by
  induction n with
  | zero => decide
  | succ n ih =>
    rw [List.range_succ, nat_sum_append]
    simp only [List.sum_cons, List.sum_nil, Nat.add_zero]
    simp only [Nat.succ_eq_add_one, Nat.mul_add, Nat.add_mul, Nat.mul_one,
      Nat.one_mul]
    omega

private theorem twice_shifted_range_sum (a n : Nat) :
    2*((List.range n).map (fun i => a+i)).sum+n = 2*(n*a)+n*n := by
  rw [shifted_sum]
  simp only [List.length_range, Nat.mul_add]
  have h := twice_range_sum n
  omega

theorem source_length (k : Nat) (hk : 2 ≤ k) :
    (sourceValues k).length = 2*k := by
  simp only [sourceValues, List.length_append, List.length_map,
    List.length_range, List.length_cons, List.length_nil]
  omega

theorem source_sum (k : Nat) (hk : 2 ≤ k) :
    (sourceValues k).sum = k*(4*k) := by
  cases k with
  | zero => omega
  | succ q =>
    have h := twice_shifted_range_sum (q+1) (2*q+1)
    have hn : 2*(q+1)-1 = 2*q+1 := by omega
    have ht : 4*(q+1)-1 = 4*q+3 := by omega
    simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul] at h
    simp only [sourceValues, Nat.succ_eq_add_one, hn, ht, nat_sum_append,
      List.sum_cons, List.sum_nil, Nat.add_zero]
    simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
    simp only [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] at h ⊢
    simp only [show 2*2 = (4 : Nat) from rfl] at h
    omega

theorem source_bounds (k : Nat) (hk : 2 ≤ k) :
    ∀ x ∈ sourceValues k, k ≤ x ∧ x < 4*k := by
  intro x hx
  simp only [sourceValues, List.mem_append, List.mem_map, List.mem_singleton] at hx
  rcases hx with ⟨i, hi, rfl⟩ | rfl
  · have hi' : i < 2*k-1 := List.mem_range.mp hi
    omega
  · omega

theorem source_positive (k : Nat) (hk : 2 ≤ k) :
    ∀ x ∈ sourceValues k, 0 < x := by
  intro x hx
  have h := source_bounds k hk x hx
  omega

theorem source_le (k : Nat) (hk : 2 ≤ k) :
    ∀ x ∈ sourceValues k, x ≤ 4*k := by
  intro x hx
  exact Nat.le_of_lt (source_bounds k hk x hx).2

theorem source_one_not_mem (k : Nat) (hk : 2 ≤ k) :
    1 ∉ sourceValues k := by
  intro h
  have hb := source_bounds k hk 1 h
  omega

theorem source_nodup (k : Nat) (hk : 2 ≤ k) :
    (sourceValues k).Nodup := by
  unfold sourceValues
  change List.Pairwise (fun a b : Nat => a ≠ b) _
  rw [List.pairwise_append]
  refine ⟨?_, ?_, ?_⟩
  · rw [List.pairwise_map]
    exact List.nodup_range.imp (by intro a b hab h; apply hab; omega)
  · simp
  · intro x hx y hy
    simp only [List.mem_singleton] at hy
    subst y
    obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hx
    have hi' := List.mem_range.mp hi
    omega

theorem reflection_length (k : Nat) (hk : 2 ≤ k) :
    (reflectionValues k).length = 2*k := by
  simpa only [reflectionValues, List.length_map] using source_length k hk

theorem reflection_one_mem (k : Nat) (hk : 2 ≤ k) :
    1 ∈ reflectionValues k := by
  apply List.mem_map.mpr
  refine ⟨4*k-1, ?_, ?_⟩
  · simp [sourceValues]
  · omega

theorem reflection_positive (k : Nat) (hk : 2 ≤ k) :
    ∀ x ∈ reflectionValues k, 0 < x := by
  intro x hx
  obtain ⟨y, hy, rfl⟩ := List.mem_map.mp hx
  have hb := source_bounds k hk y hy
  omega

theorem reflection_nodup (k : Nat) (hk : 2 ≤ k) :
    (reflectionValues k).Nodup := by
  unfold reflectionValues
  change List.Pairwise (fun a b : Nat => a ≠ b) _
  rw [List.pairwise_map]
  apply (source_nodup k hk).imp_of_mem
  intro a b ha hb hab heq
  have hba := source_bounds k hk a ha
  have hbb := source_bounds k hk b hb
  apply hab
  omega

theorem different_underlying_sets (k : Nat) (hk : 2 ≤ k) :
    ¬ (∀ x : Nat, x ∈ sourceValues k ↔ x ∈ reflectionValues k) := by
  intro h
  exact source_one_not_mem k hk ((h 1).mpr (reflection_one_mem k hk))

theorem source_three : sourceValues 3 = [3,4,5,6,7,11] := by decide

theorem reflection_three : reflectionValues 3 = [9,8,7,6,5,1] := by decide

#print axioms source_sum
#print axioms source_nodup
#print axioms reflection_nodup

end JSP399General
