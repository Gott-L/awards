# Internal review of the general half-size reflection proof

Review date: 2026-09-17. This review covers `ReflectionCore.lean` and `ReflectionConstruction.lean` at the hashes below. It does not certify a later integration file unless separately stated.

The core proof was examined by a sibling agent that did not write it. The same reviewer wrote the construction module, so review of that module is not independent of its author. Both agents use the same assistant and tool environment. This is not independent human peer review, official prize verification, or evidence of acceptance or award eligibility.

## Result and mathematical scope

No mathematical or statement-encoding defect was found in the reviewed core. Its `SameHalfSums` predicate expresses an explicit sum-preserving bijection on all masks selecting exactly k of 2k positions. Together with the proved representation lemmas and the construction's distinct entries, this preserves every subset sum's multiplicity.

For every integer k at least 2, the construction is the list

```text
k, k+1, ..., 3k-2, 4k-1.
```

It has 2k distinct positive integer entries, total sum 4k², and every entry lies strictly between 0 and 4k. Reflecting each entry x to 4k-x gives another such list. The source contains no 1, while the reflected list contains 1, so their underlying sets are different.

The interval part has 2k-1 entries and sum (2k-1)²; adding 4k-1 gives 4k² = k(4k). For a selected k-element subset S, select the complementary positions in the reflected list. Its sum is

```text
k(4k) - (sum of all source entries - sum(S)) = sum(S).
```

Complementation is its own inverse, so this correspondence is a bijection and preserves multiplicities, including when several different subsets share the same sum.

This addresses the known obstruction n = 2k for every k at least 2. It does not contradict the reconstruction theorem when n is sufficiently large relative to a fixed k. No claim of a new mathematical theorem or first formalization is made. The [Erdős #494 discussion](https://www.erdosproblems.com/494) already records the obstruction and links an earlier formalization in `hjyuh/formal-conjectures`.

## Representation and multiplicities

`ValidMask n k mask` requires both the exact mask length n and exactly k occurrences of `true`. `HalfMask k` is the subtype of masks satisfying these conditions with n = 2k. Its elements therefore include every possible choice of k positions, without extra positions or an omitted length condition.

`weightedSum` and `selected` both stop when either input list ends. This general definition does not introduce a gap: all results applying them to half-size subsets enforce equality of the mask and source lengths.

The reviewed bridge to ordinary subsets consists of:

- `selected_sublist`: selected entries form a sublist of the original list.
- `selected_length`: under the exact-length hypothesis, the selected list has as many entries as there are true mask bits.
- `selected_sum`: the sum of the selected entries equals `weightedSum`.
- `selected_complete`: every sublist is represented by a mask of the source list's exact length.
- `selected_injective`: if the source has no repeated entries, two masks of the correct length selecting the same sublist are equal.
- `mask_representation`: every k-entry sublist of a distinct-entry source of length 2k has exactly one representing `HalfMask k`.

For a distinct-entry list, an unordered subset has one sublist in the ambient list's order. This is the standard list representation of finite subsets used here. The files do not introduce a separate `Finset` or `Multiset` object; the formal conclusion is an explicit bijection of this complete index domain. Such a bijection preserves each sum's multiplicity, which is stronger than merely proving equality of the attainable sum values.

`SameHalfSums` requires both source lengths to equal 2k, functions f and g on the entire `HalfMask k` type, both inverse equations, and equality of the sum for every mask under f. It does not identify or discard masks with equal sums. The witness functions in `half_size_reflection_bijection` are both `complementHalf k`.

`complement_count` proves that the number of selected and unselected positions adds to the mask length. It follows that complementation preserves the half-size condition. `complementHalf_involution` supplies both inverse equations. `weightedSum_partition` and `reflected_weight_partition` prove the sum identity, and the hypothesis x ≤ C prevents natural subtraction from truncating the reflected entries. `reflection_preserves_weight` then uses the source total kC to prove the desired equality.

The construction provides every hypothesis required by the core: `source_length`, `source_sum`, and `source_le`, as well as `source_nodup` and `reflection_nodup` needed for the ordinary-subset interpretation on both sides.

## Clean compilation and trust audit

Each reviewed source was copied into a separate review directory and compiled into a freshly generated output file with `LEAN_PATH` cleared. No existing project `.olean` file was used. Both files import only `Std` and do not import one another. The compiler was Lean 4.19.0, x86_64-w64-windows-gnu, commit `6caaee842e94` (Release).

The following commands both exited with code 0 and no warnings:

```text
lean -DwarningAsError=true -o ReflectionCore.olean ReflectionCore.lean
lean -DwarningAsError=true -o ReflectionConstruction.olean ReflectionConstruction.lean
```

Reviewed source SHA-256 hashes:

```text
ReflectionCore.lean
4bc8812ac702bad9f6cd6bd21cc7780faedf3f19753f7d33bd8807227c321c74

ReflectionConstruction.lean
7f304bd4fdfed3f7a0bd43a2950033eea2e5110356ede7706c7e3126084d9c13
```

Both source files contain no `sorry`, `admit`, custom `axiom` declaration, `native_decide`, or `unsafe`. The compiler reported these axiom dependencies:

```text
ReflectionCore.half_size_reflection_bijection:
  [propext, Classical.choice, Quot.sound]
ReflectionCore.mask_representation:
  [propext, Classical.choice, Quot.sound]
JSP399General.source_sum:
  [propext, Quot.sound]
JSP399General.source_nodup:
  [propext, Classical.choice, Quot.sound]
JSP399General.reflection_nodup:
  [propext, Classical.choice, Quot.sound]
```

These are Lean's standard foundational axioms. The files introduce no additional mathematical assumptions, but they must not be described as having zero axiom dependencies.

## Final integration endpoint review

The same sibling reviewer separately read `Jsp399General.lean`, which the reviewer did not author. Its SHA-256 is:

```text
3ccea78b91f2884c685dbe12bd6ba54a590058250f50a546973ef9a897fcd3b8
```

Its two imported source files retain the exact hashes reviewed above. This additional check concerns the integration's definitions and theorem statements; no extra compilation was performed for this section. The coordinating agent reports a successful fresh compilation and axiom audit of the complete submission.

`ExactSubsetEncoding` includes both directions of the representation: every valid mask gives a distinct-entry k-term sublist with the ordinary sum, and every k-term sublist has exactly one valid mask. `IsHalfSumCounterexample` explicitly requires both lengths to equal 2k, no duplicate entries, positive entries, different underlying membership sets, `SameHalfSums`, and exact subset encodings for both lists. Thus its endpoint does not omit the cardinality, distinctness, positivity, or multiplicity conditions.

`general_half_sum_counterexamples` proves this complete predicate for the concrete source and reflection for every k at least 2; the existential theorem supplies those same two lists as witnesses. `explicit_complement_bijection` also states the involution and the individual sum-preservation identity directly. The imported hypotheses match with C = 4k and total sum k(4k). No new mathematical or statement-encoding gap was found in this integration. The conclusion remains the known n = 2k obstruction, with no claim of first formalization or of disproving eventual uniqueness for fixed k.
