import ReflectionCore
import ReflectionConstruction

/-!
For every k >= 2, two different sets of 2*k distinct positive integers
have the same multiset of k-element subset sums.

This is an independent standard-library-only formalization of a classical
reflection obstruction, not a new mathematical discovery or a claim of first
formalization. The mechanism is in Selfridge and Straus (1958), Theorem 3.
It is not the eventual-uniqueness theorem for fixed k and large cardinality.
MIT license. Written with OpenAI Codex assistance, 2026-09-17.
-/

namespace JSP399General

open ReflectionCore

/-- Every valid mask gives a genuine k-element sublist and its ordinary sum;
every such sublist is represented by exactly one mask. For a list without
duplicate entries, sublists in the inherited order represent its subsets. -/
def ExactSubsetEncoding (k : Nat) (xs : List Nat) : Prop :=
  (∀ mask : HalfMask k,
    (selected xs mask.val).Sublist xs ∧
    (selected xs mask.val).length = k ∧
    (selected xs mask.val).Nodup ∧
    (selected xs mask.val).sum = weightedSum xs mask.val) ∧
  ∀ ys : List Nat, ys.Sublist xs → ys.length = k →
    ∃ mask : HalfMask k, selected xs mask.val = ys ∧
      ∀ other : HalfMask k, selected xs other.val = ys → other = mask

theorem exact_subset_encoding (k : Nat) (xs : List Nat)
    (hlen : xs.length = 2*k) (hn : xs.Nodup) : ExactSubsetEncoding k xs := by
  constructor
  · intro mask
    have hs := selected_sublist xs mask.val
    have hm : mask.val.length = xs.length := mask.property.1.trans hlen.symm
    refine ⟨hs, ?_, hs.nodup hn, selected_sum xs mask.val⟩
    exact (selected_length xs mask.val hm).trans mask.property.2
  · intro ys hs hl
    exact mask_representation k xs ys hlen hn hs hl

/-- An explicit counterexample with cardinality, positivity, set inequality,
and equality with multiplicities, together with the subset-encoding audit. -/
def IsHalfSumCounterexample (k : Nat) (xs ys : List Nat) : Prop :=
  xs.length = 2*k ∧ ys.length = 2*k ∧
  xs.Nodup ∧ ys.Nodup ∧
  (∀ x ∈ xs, 0 < x) ∧ (∀ y ∈ ys, 0 < y) ∧
  (¬ (∀ z : Nat, z ∈ xs ↔ z ∈ ys)) ∧
  SameHalfSums k xs ys ∧
  ExactSubsetEncoding k xs ∧ ExactSubsetEncoding k ys

theorem source_reflection_same_sums (k : Nat) (hk : 2 ≤ k) :
    SameHalfSums k (sourceValues k) (reflectionValues k) := by
  exact half_size_reflection_bijection (4*k) k (sourceValues k)
    (source_length k hk) (source_sum k hk) (source_le k hk)

/-- The complement map supplies the precise bijection used by the endpoint. -/
theorem explicit_complement_bijection (k : Nat) (hk : 2 ≤ k) :
    (∀ mask : HalfMask k,
      complementHalf k (complementHalf k mask) = mask) ∧
    (∀ mask : HalfMask k,
      weightedSum (reflectionValues k) (complementHalf k mask).val =
        weightedSum (sourceValues k) mask.val) := by
  refine ⟨complementHalf_involution k, ?_⟩
  exact reflection_preserves_weight (4*k) k (sourceValues k)
    (source_length k hk) (source_sum k hk) (source_le k hk)

/-- For every k >= 2, the displayed positive integer construction gives two
different 2*k-element sets with identical k-subset-sum multisets. -/
theorem general_half_sum_counterexamples (k : Nat) (hk : 2 ≤ k) :
    IsHalfSumCounterexample k (sourceValues k) (reflectionValues k) := by
  exact ⟨source_length k hk, reflection_length k hk,
    source_nodup k hk, reflection_nodup k hk,
    source_positive k hk, reflection_positive k hk,
    different_underlying_sets k hk, source_reflection_same_sums k hk,
    exact_subset_encoding k (sourceValues k) (source_length k hk) (source_nodup k hk),
    exact_subset_encoding k (reflectionValues k)
      (reflection_length k hk) (reflection_nodup k hk)⟩

theorem exists_general_half_sum_counterexamples (k : Nat) (hk : 2 ≤ k) :
    ∃ xs ys : List Nat, IsHalfSumCounterexample k xs ys :=
  ⟨sourceValues k, reflectionValues k, general_half_sum_counterexamples k hk⟩

#print axioms exact_subset_encoding
#print axioms explicit_complement_bijection
#print axioms general_half_sum_counterexamples
#print axioms exists_general_half_sum_counterexamples

end JSP399General
