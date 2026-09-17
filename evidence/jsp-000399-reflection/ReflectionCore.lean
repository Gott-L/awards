import Std

/-!
The classical half-size reflection construction, proved for arbitrary lists.
The subsets are represented by Boolean masks of the prescribed length.
The complement map is an explicit involutive bijection of half-size masks.
MIT license. Written with OpenAI Codex assistance, 2026-09-17.
-/

namespace ReflectionCore

def complement (mask : List Bool) : List Bool := mask.map Bool.not

def reflect (C : Nat) (xs : List Nat) : List Nat :=
  xs.map (fun x => C - x)

def weightedSum : List Nat → List Bool → Nat
  | [], _ => 0
  | _, [] => 0
  | x :: xs, b :: bs => (if b then x else 0) + weightedSum xs bs

def ValidMask (n k : Nat) (mask : List Bool) : Prop :=
  mask.length = n ∧ mask.count true = k

abbrev HalfMask (k : Nat) := {mask : List Bool // ValidMask (2*k) k mask}

@[simp] theorem complement_nil : complement [] = [] := rfl

@[simp] theorem complement_cons (b : Bool) (bs : List Bool) :
    complement (b :: bs) = (!b) :: complement bs := rfl

@[simp] theorem complement_length (mask : List Bool) :
    (complement mask).length = mask.length := by
  simp [complement]

@[simp] theorem complement_involution (mask : List Bool) :
    complement (complement mask) = mask := by
  induction mask with
  | nil => rfl
  | cons b bs ih => cases b <;> simp [ih]

theorem complement_count (mask : List Bool) :
    (complement mask).count true + mask.count true = mask.length := by
  induction mask with
  | nil => rfl
  | cons b bs ih => cases b <;> simp_all <;> omega

theorem complement_valid (k : Nat) (mask : List Bool)
    (h : ValidMask (2*k) k mask) : ValidMask (2*k) k (complement mask) := by
  obtain ⟨hlen, hcount⟩ := h
  refine ⟨by simpa using hlen, ?_⟩
  have hc := complement_count mask
  omega

def complementHalf (k : Nat) (mask : HalfMask k) : HalfMask k :=
  ⟨complement mask.val, complement_valid k mask.val mask.property⟩

theorem complementHalf_involution (k : Nat) (mask : HalfMask k) :
    complementHalf k (complementHalf k mask) = mask := by
  apply Subtype.eq
  exact complement_involution mask.val

theorem complementHalf_injective (k : Nat) (a b : HalfMask k)
    (h : complementHalf k a = complementHalf k b) : a = b := by
  have hh := congrArg (complementHalf k) h
  simpa [complementHalf_involution] using hh

theorem complementHalf_surjective (k : Nat) (b : HalfMask k) :
    ∃ a : HalfMask k, complementHalf k a = b :=
  ⟨complementHalf k b, complementHalf_involution k b⟩

/-- Equality of the multisets of half-size subset sums is represented by
an explicit bijection between all half-size masks that preserves each sum.
The inverse equations ensure that multiplicities are preserved. -/
def SameHalfSums (k : Nat) (xs ys : List Nat) : Prop :=
  xs.length = 2*k ∧ ys.length = 2*k ∧
  ∃ f g : HalfMask k → HalfMask k,
    (∀ m, g (f m) = m) ∧ (∀ m, f (g m) = m) ∧
    ∀ m, weightedSum ys (f m).val = weightedSum xs m.val

theorem weightedSum_partition (xs : List Nat) (mask : List Bool)
    (hlen : mask.length = xs.length) :
    weightedSum xs mask + weightedSum xs (complement mask) = xs.sum := by
  induction xs generalizing mask with
  | nil =>
      cases mask with
      | nil => rfl
      | cons b bs => simp at hlen
  | cons x xs ih =>
      cases mask with
      | nil => simp at hlen
      | cons b bs =>
          have hl : bs.length = xs.length := by simpa using hlen
          have hp := ih bs hl
          cases b <;> simp only [weightedSum, complement_cons, Bool.not_false,
            Bool.not_true, Bool.false_eq_true, if_false, if_true, Nat.zero_add,
            List.sum_cons] <;> omega

theorem reflected_weight_partition (C : Nat) (xs : List Nat) (mask : List Bool)
    (hbound : ∀ x ∈ xs, x ≤ C) (hlen : mask.length = xs.length) :
    weightedSum (reflect C xs) mask + weightedSum xs mask = C * mask.count true := by
  induction xs generalizing mask with
  | nil =>
      cases mask with
      | nil => simp [weightedSum, reflect]
      | cons b bs => simp at hlen
  | cons x xs ih =>
      cases mask with
      | nil => simp at hlen
      | cons b bs =>
          have hx : x ≤ C := hbound x (by simp)
          have hb : ∀ y ∈ xs, y ≤ C := by
            intro y hy
            exact hbound y (by simp [hy])
          have hl : bs.length = xs.length := by simpa using hlen
          have hp := ih bs hb hl
          cases b <;> simp [reflect, weightedSum, Nat.mul_add] at * <;> omega

theorem reflection_preserves_weight (C k : Nat) (xs : List Nat)
    (hlen : xs.length = 2*k) (hsum : xs.sum = k*C)
    (hbound : ∀ x ∈ xs, x ≤ C) (mask : HalfMask k) :
    weightedSum (reflect C xs) (complementHalf k mask).val =
      weightedSum xs mask.val := by
  have hl : mask.val.length = xs.length := mask.property.1.trans hlen.symm
  have hp := weightedSum_partition xs mask.val hl
  have hc := reflected_weight_partition C xs (complement mask.val) hbound
    (by simpa using hl)
  have hm := (complement_valid k mask.val mask.property).2
  change weightedSum (reflect C xs) (complement mask.val) = weightedSum xs mask.val
  rw [hm, Nat.mul_comm C k] at hc
  omega

theorem reflect_involution (C : Nat) (xs : List Nat)
    (hbound : ∀ x ∈ xs, x ≤ C) : reflect C (reflect C xs) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      have hx : x ≤ C := hbound x (by simp)
      have hb : ∀ y ∈ xs, y ≤ C := by
        intro y hy
        exact hbound y (by simp [hy])
      have he : C - (C-x) = x := by omega
      simpa [reflect, he] using congrArg (List.cons x) (ih hb)

/-- The explicit bijection in the reflection construction is complementation;
it is its own inverse and preserves each sum. -/
theorem half_size_reflection_bijection (C k : Nat) (xs : List Nat)
    (hlen : xs.length = 2*k) (hsum : xs.sum = k*C)
    (hbound : ∀ x ∈ xs, x ≤ C) : SameHalfSums k xs (reflect C xs) := by
  refine ⟨hlen, by simpa [reflect] using hlen, complementHalf k, complementHalf k,
    complementHalf_involution k, complementHalf_involution k, ?_⟩
  exact reflection_preserves_weight C k xs hlen hsum hbound

/-- The actual selected entries, in their original order. -/
def selected : List Nat → List Bool → List Nat
  | [], _ => []
  | _, [] => []
  | x :: xs, b :: bs => if b then x :: selected xs bs else selected xs bs

theorem selected_sublist (xs : List Nat) (mask : List Bool) :
    (selected xs mask).Sublist xs := by
  induction xs generalizing mask with
  | nil => simp [selected]
  | cons x xs ih =>
      cases mask with
      | nil => simp [selected]
      | cons b bs =>
          cases b
          · exact (ih bs).cons x
          · exact (ih bs).cons₂ x

theorem selected_length (xs : List Nat) (mask : List Bool)
    (hlen : mask.length = xs.length) :
    (selected xs mask).length = mask.count true := by
  induction xs generalizing mask with
  | nil => cases mask <;> simp_all [selected]
  | cons x xs ih =>
      cases mask with
      | nil => simp at hlen
      | cons b bs =>
          have hl : bs.length = xs.length := by simpa using hlen
          have hp := ih bs hl
          cases b <;> simp_all [selected]

theorem selected_sum (xs : List Nat) (mask : List Bool) :
    (selected xs mask).sum = weightedSum xs mask := by
  induction xs generalizing mask with
  | nil => simp [selected, weightedSum]
  | cons x xs ih =>
      cases mask with
      | nil => simp [selected, weightedSum]
      | cons b bs => cases b <;> simp [selected, weightedSum, ih]

/-- Every sublist comes from a mask with exactly the original list's length. -/
theorem selected_complete (xs ys : List Nat) (h : ys.Sublist xs) :
    ∃ mask : List Bool, mask.length = xs.length ∧ selected xs mask = ys := by
  induction h with
  | slnil => exact ⟨[], rfl, rfl⟩
  | cons x _ ih =>
      obtain ⟨mask, hl, hs⟩ := ih
      exact ⟨false :: mask, by simpa using hl, by simpa [selected] using hs⟩
  | cons₂ x _ ih =>
      obtain ⟨mask, hl, hs⟩ := ih
      exact ⟨true :: mask, by simpa using hl, by simpa [selected] using hs⟩

/-- For a list of distinct entries, two masks of the correct length cannot
encode the same selected sublist. -/
theorem selected_injective (xs : List Nat) (hn : xs.Nodup)
    (a b : List Bool) (ha : a.length = xs.length) (hb : b.length = xs.length)
    (he : selected xs a = selected xs b) : a = b := by
  induction xs generalizing a b with
  | nil => cases a <;> cases b <;> simp_all
  | cons x xs ih =>
      obtain ⟨hx, hn⟩ := List.nodup_cons.mp hn
      cases a with
      | nil => simp at ha
      | cons ba as =>
          cases b with
          | nil => simp at hb
          | cons bb bs =>
              have hla : as.length = xs.length := by simpa using ha
              have hlb : bs.length = xs.length := by simpa using hb
              cases ba <;> cases bb
              · have hh : selected xs as = selected xs bs := he
                exact congrArg (List.cons false) (ih hn as bs hla hlb hh)
              · have hxmem : x ∈ selected xs as := by
                  change selected xs as = x :: selected xs bs at he
                  rw [he]
                  simp
                exact False.elim (hx ((selected_sublist xs as).subset hxmem))
              · have hxmem : x ∈ selected xs bs := by
                  change x :: selected xs as = selected xs bs at he
                  rw [← he]
                  simp
                exact False.elim (hx ((selected_sublist xs bs).subset hxmem))
              · have hh : selected xs as = selected xs bs :=
                  (List.cons.inj he).2
                exact congrArg (List.cons true) (ih hn as bs hla hlb hh)

/-- The masks cover every k-element sublist exactly once when entries are
distinct. This connects the mask formalization to ordinary subsets. -/
theorem mask_representation (k : Nat) (xs ys : List Nat)
    (hlen : xs.length = 2*k) (hn : xs.Nodup)
    (hsub : ys.Sublist xs) (hsize : ys.length = k) :
    ∃ mask : HalfMask k,
      selected xs mask.val = ys ∧
      ∀ other : HalfMask k, selected xs other.val = ys → other = mask := by
  obtain ⟨mask, hm, hs⟩ := selected_complete xs ys hsub
  have hc : mask.count true = k := by
    rw [← selected_length xs mask hm, hs, hsize]
  let m : HalfMask k := ⟨mask, hm.trans hlen, hc⟩
  refine ⟨m, hs, ?_⟩
  intro other ho
  apply Subtype.eq
  exact selected_injective xs hn other.val mask
    (other.property.1.trans hlen.symm) hm (ho.trans hs.symm)

#print axioms half_size_reflection_bijection
#print axioms mask_representation

end ReflectionCore
