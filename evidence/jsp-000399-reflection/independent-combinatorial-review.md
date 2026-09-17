# Independent combinatorial review of the JSP-000399 witness

The witness sets are

- A = {3, 4, 5, 6, 7, 11}.
- B = {1, 5, 6, 7, 8, 9}.

Each has six distinct positive integer elements. They are different as sets (1 belongs only to B). Their total sums are both 36, and B = {12 - a : a in A}.

For every three-element subset S of A, define T = {12 - a : a in A \\ S}. The complement A \\ S has three elements. Reflection is injective, so T is a three-element subset of B. This map is a bijection: its inverse sends T to A \\ {12 - b : b in T}. Its sum is

sum(T) = 3 * 12 - sum(A \\ S) = 36 - (36 - sum(S)) = sum(S).

This is a bijection between three-element subsets, not merely between attainable sums. It therefore preserves every sum's multiplicity.

Independent exhaustive enumeration of all C(6,3) = 20 triples on both sides gives the identical sorted list:

```text
12, 13, 14, 14, 15, 15, 16, 16, 17, 18,
18, 19, 20, 20, 21, 21, 22, 22, 23, 24
```

Translating both sets by any nonnegative integer t preserves distinctness and positivity, and adds 3t to every triple sum. Their minima remain respectively 3+t and 1+t, so they remain different.

Scope: this proves non-uniqueness for the literal unrestricted reconstruction question with k = 3 and n = 6. It does not prove the sufficiently-large-n reconstruction theorem. The n = 2k reflection construction is already noted in the source discussion; this submission's proposed contribution is a formal certificate, not a novel mathematical solution.

Sources reviewed: the prize catalog's JSP-000399 entry; [Erdős Problem #494](https://www.erdosproblems.com/494). The latter explicitly distinguishes the unrestricted statement from the sufficiently-large-size formulation.

## Lean source review completed

The sibling review agent separately read and compiled `Jsp399.lean` on 2026-09-17 with Lean 4.19.0, x86_64-w64-windows-gnu, commit `6caaee842e94` (Release). The process exited successfully with code 0. The final revision's two added theorems were subsequently checked, and the final file was compiled again successfully using the same version. From the directory containing the source, the reproducible command is:

```text
lean Jsp399.lean
```

Reviewed file SHA-256:

```text
1a6e24bbc1f9589f1b23c113e0824a4d9d9dd6290c5d0432c4cf51b7cdf9fb26
```

The source's explicit `triples` list was separately parsed and compared to Python's `itertools.combinations(range(6), 3)`. The lists matched exactly; there were 20 triples and no repeated triples. Within Lean, `triples_complete` proves that membership is equivalent to strictly increasing indices, and `triples_nodup` proves no duplication.

`tripleSums` maps every such index triple to its sum without removing repeated values. `SameTripleSums` is `List.Perm`, which equates lists with multiplicities. Thus the formal predicate expresses the required multiset equality rather than just equality of the set of attainable sums.

The strict-increase and positivity theorems verify that the six indices represent six different positive integers. The set-inequality statements compare the images of the two functions rather than merely asserting different orderings. For translations, `translated_tripleSums` proves the general addition-of-3t identity; permutation preservation then yields `translated_same_sums`. The witness t+1 proves that the translated underlying sets remain different.

The final revision adds `different_translations`, which proves injectivity of the parameter-to-tuple map for B: equality of the two translated functions implies equality at index 0, hence t+1 = u+1 and t = u. Its formal conclusion concerns functions; because all these tuples are strictly increasing, they also describe different underlying sets for different parameters.

The final revision also adds `arbitrarily_large_counterexamples`. Its witnesses are `translate M A` and `translate M B`. Positivity of A and B ensures that every witness entry is strictly greater than M. The remaining conclusions are exactly the strict-increase, equal-multiset, and different-set conclusions already proved in `counterexamples M`. This establishes arbitrarily large element values while the cardinality remains six; it makes no assertion of counterexamples with arbitrarily large cardinality. Both added theorem statements match their proofs.

The source imports only `Std`. A token scan found no `sorry`, `admit`, custom `axiom` declaration, `native_decide`, or `unsafe`. The successful compilation used the kernel-checked `decide` and `omega` proof paths.

The compiler's axiom report is:

```text
JSP399.triples_complete: [propext]
JSP399.triples_nodup: [propext]
JSP399.base_same_sums: [propext, Classical.choice, Quot.sound]
JSP399.counterexamples: [propext, Classical.choice, Quot.sound]
JSP399.different_translations: [propext, Quot.sound]
JSP399.arbitrarily_large_counterexamples: [propext, Classical.choice, Quot.sound]
```

These are Lean's standard foundational axioms, not additional mathematical assumptions. This file must not be described as having zero axiom dependencies.

No mathematical or statement-encoding defect was found in the reviewed version. This is an internal cross-check by a second agent using the same assistant/tool environment. It is not independent human peer review, official prize verification, or evidence of acceptance or award eligibility.
