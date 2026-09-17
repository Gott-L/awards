import Std

/-!
An explicit six-element, three-sum ambiguity for JSP-000399 / Erdos 494.
This formalizes a known obstruction, not the eventual-uniqueness theorem.
The general reflection/complement construction is Theorem 3 of Selfridge
and Straus, Pacific Journal of Mathematics 8 (1958), 847-856.
Written with OpenAI Codex assistance, 2026-09-17. MIT license.
-/

namespace JSP399

abbrev Triple := Fin 6 × Fin 6 × Fin 6

/-- Every three-element subset of six indices, in increasing order. -/
def triples : List Triple :=
  [(0,1,2), (0,1,3), (0,1,4), (0,1,5),
   (0,2,3), (0,2,4), (0,2,5), (0,3,4), (0,3,5), (0,4,5),
   (1,2,3), (1,2,4), (1,2,5), (1,3,4), (1,3,5), (1,4,5),
   (2,3,4), (2,3,5), (2,4,5), (3,4,5)]

theorem triples_complete : ∀ i j k : Fin 6,
    (i,j,k) ∈ triples ↔ i < j ∧ j < k := by decide

theorem triples_nodup : triples.Nodup := by decide

theorem triples_length : triples.length = 20 := by decide

/-- Equal sums from different triples are retained as repeated list entries. -/
def tripleSums (a : Fin 6 → Nat) : List Nat :=
  triples.map (fun p => a p.1 + a p.2.1 + a p.2.2)

/-- Equality as multisets, represented by list permutation. -/
def SameTripleSums (a b : Fin 6 → Nat) : Prop :=
  (tripleSums a).Perm (tripleSums b)

def A (i : Fin 6) : Nat := [3,4,5,6,7,11][i.val]
def B (i : Fin 6) : Nat := [1,5,6,7,8,9][i.val]

theorem A_strict : ∀ i j : Fin 6, i < j → A i < A j := by decide
theorem B_strict : ∀ i j : Fin 6, i < j → B i < B j := by decide
theorem A_positive : ∀ i : Fin 6, 0 < A i := by decide
theorem B_positive : ∀ i : Fin 6, 0 < B i := by decide

theorem base_same_sums : SameTripleSums A B := by
  unfold SameTripleSums
  decide

theorem base_different_sets : ¬ (∀ x : Nat,
    (∃ i : Fin 6, A i = x) ↔ (∃ j : Fin 6, B j = x)) := by
  intro h
  have hB : ∃ j : Fin 6, B j = 1 := ⟨0, rfl⟩
  obtain ⟨i, hi⟩ := (h 1).mpr hB
  have hn : ∀ i : Fin 6, A i ≠ 1 := by decide
  exact hn i hi

def translate (t : Nat) (a : Fin 6 → Nat) : Fin 6 → Nat :=
  fun i => t + a i

theorem translated_tripleSums (t : Nat) (a : Fin 6 → Nat) :
    tripleSums (translate t a) = (tripleSums a).map (fun s => 3*t+s) := by
  simp only [tripleSums, List.map_map]
  apply List.map_congr_left
  intro p _
  simp only [translate, Function.comp_apply]
  omega

theorem translated_same_sums (t : Nat) :
    SameTripleSums (translate t A) (translate t B) := by
  unfold SameTripleSums
  rw [translated_tripleSums, translated_tripleSums]
  exact base_same_sums.map (fun s => 3*t+s)

theorem translated_different_sets (t : Nat) : ¬ (∀ x : Nat,
    (∃ i : Fin 6, translate t A i = x) ↔
      (∃ j : Fin 6, translate t B j = x)) := by
  intro h
  have hB : ∃ j : Fin 6, translate t B j = t+1 := ⟨0, rfl⟩
  obtain ⟨i, hi⟩ := (h (t+1)).mpr hB
  have lower : ∀ i : Fin 6, 3 ≤ A i := by decide
  have hl := lower i
  simp only [translate] at hi
  omega

/-- For every translation, two different sets of six positive integers have
identical three-element-subset-sum multisets. Strict increase ensures that
six positions represent six distinct elements. -/
theorem counterexamples (t : Nat) :
    (∀ i : Fin 6, 0 < translate t A i ∧ 0 < translate t B i) ∧
    (∀ i j : Fin 6, i < j → translate t A i < translate t A j) ∧
    (∀ i j : Fin 6, i < j → translate t B i < translate t B j) ∧
    SameTripleSums (translate t A) (translate t B) ∧
    ¬ (∀ x : Nat, (∃ i : Fin 6, translate t A i = x) ↔
      (∃ j : Fin 6, translate t B j = x)) := by
  refine ⟨?_, ?_, ?_, translated_same_sums t, translated_different_sets t⟩
  · intro i
    have ha := A_positive i
    have hb := B_positive i
    simp only [translate]
    omega
  · intro i j hij
    have ha := A_strict i j hij
    simp only [translate]
    omega
  · intro i j hij
    have hb := B_strict i j hij
    simp only [translate]
    omega

theorem different_translations (t u : Nat)
    (h : translate t B = translate u B) : t = u := by
  have h0 := congrArg (fun f : Fin 6 → Nat => f 0) h
  change t + 1 = u + 1 at h0
  omega

/-- The elements, though not the cardinalities, can be arbitrarily large. -/
theorem arbitrarily_large_counterexamples (M : Nat) :
    ∃ a b : Fin 6 → Nat,
      (∀ i : Fin 6, M < a i ∧ M < b i) ∧
      (∀ i j : Fin 6, i < j → a i < a j) ∧
      (∀ i j : Fin 6, i < j → b i < b j) ∧
      SameTripleSums a b ∧
      ¬ (∀ x : Nat, (∃ i : Fin 6, a i = x) ↔
        (∃ j : Fin 6, b j = x)) := by
  refine ⟨translate M A, translate M B, ?_, (counterexamples M).2⟩
  intro i
  have ha := A_positive i
  have hb := B_positive i
  simp only [translate]
  omega

#print axioms triples_complete
#print axioms triples_nodup
#print axioms base_same_sums
#print axioms counterexamples
#print axioms different_translations
#print axioms arbitrarily_large_counterexamples

end JSP399
