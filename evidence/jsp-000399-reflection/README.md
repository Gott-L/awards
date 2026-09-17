# JSP-000399: the half-size reflection obstruction

This packet gives an independently written Lean 4 implementation of the classical half-size reflection construction, using only the bundled standard library. For every integer $k\ge2$, it constructs two different sets of $2k$ distinct positive integers with identical multisets of $k$-element subset sums. A separate concrete certificate covers the six-element example and all its common nonnegative translates.

**A prior Lean formalization already exists.** The `erdos_494.variants.card_eq_2k` theorem in [hjyuh's immutable proof commit](https://github.com/hjyuh/formal-conjectures/blob/e0da6ec78953b17618895a093d4bee90fd3f6f67/FormalConjectures/ErdosProblems/494.lean#L916), dated 12 March 2026, proves the general $k>2$, $n=2k$ non-uniqueness variant. [Google DeepMind Formal Conjectures PR 3525](https://github.com/google-deepmind/formal-conjectures/pull/3525), merged on 1 September 2026, registers the proof link and records that its original commit passed the repository build check. This packet does not claim the first Lean proof or a new mathematical discovery. The cited prior source is not a dependency of this implementation.

We request review as **an independent standard-library implementation and community evidence** for [JSP-000399](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#JSP-000399), corresponding to [Erdős problem 494](https://www.erdosproblems.com/494). The classical mechanism is attributed to Selfridge–Straus (1958), Theorem 3. This submission does not establish acceptance, priority, or award eligibility, and does not formalize the sufficiently-large-cardinality reconstruction theorem.

## General statement and proof

For a finite set $X$, let $S_k(X)$ contain one sum for every $k$-element subset of $X$, retaining repetitions from different subsets. For each $k\ge2$, put

$$
A_k=\{k,k+1,\ldots,3k-2\}\cup\{4k-1\},\qquad
B_k=\{1\}\cup\{k+2,k+3,\ldots,3k\}.
$$

Both sets have $2k$ distinct positive elements. They differ because $1\in B_k\setminus A_k$. Their total sums are $4k^2$, and $B_k=\{4k-a:a\in A_k\}$. If $U$ is a $k$-element subset of $A_k$, define

$$
\Phi(U)=\{4k-a:a\in A_k\setminus U\}.
$$

Complementation followed by reflection bijects the $k$-element subsets of the two sets, and

$$
\sum\Phi(U)=k(4k)-\sum(A_k\setminus U)
=4k^2-(4k^2-\sum U)=\sum U.
$$

The bijection preserves every sum's multiplicity. Hence $S_k(A_k)=S_k(B_k)$.

The generic Lean lemma proves this mechanism for any list `xs` of length `2*k`, total `k*C`, and entries at most `C`. The explicit construction supplies these hypotheses with `C=4*k`, together with distinctness, strict positivity of the reflected values, and inequality of the underlying sets.

## Six-element example and translations

At $k=3$, the underlying sets are

$$
A=\{3,4,5,6,7,11\},\qquad B=\{1,5,6,7,8,9\}.
$$

Their common sorted list of twenty three-element sums is

```text
12, 13, 14, 14, 15, 15, 16, 16, 17, 18,
18, 19, 20, 20, 21, 21, 22, 22, 23, 24.
```

For every nonnegative integer $t$, the separately verified pair $t+A,t+B$ retains these properties, and its twenty sums increase by $3t$. Different parameters give different pairs. Every element can be made larger than an arbitrary bound, while the cardinality stays six. The general construction module stores the reflected list in descending order; the concrete certificate stores the same underlying set in ascending order.

## Source modules and semantics

| Module | Content |
| --- | --- |
| [ReflectionCore.lean](ReflectionCore.lean) | Generic weighted sums, half-size Boolean masks, complement and reflection, the explicit inverse maps, and the proof relating masks to sublists. |
| [ReflectionConstruction.lean](ReflectionConstruction.lean) | The lists `sourceValues k` and `reflectionValues k`; their lengths, sums, bounds, lack of duplicates, positivity, and different underlying sets. |
| [Jsp399General.lean](Jsp399General.lean) | The combined theorem for every `k ≥ 2`, including the precise correspondence between masks and subsets. |
| [Jsp399.lean](Jsp399.lean) | The concrete six-element `List.Perm` certificate and the infinite family of common nonnegative translates. |

The general endpoint is `JSP399General.general_half_sum_counterexamples`; `exists_general_half_sum_counterexamples` gives its existential form. `IsHalfSumCounterexample` explicitly includes both lengths, `Nodup` for both lists, positivity, inequality of their underlying membership predicates, `SameHalfSums`, and `ExactSubsetEncoding` for each list.

The general proof represents a subset by a Boolean list with the same length as the original list and exactly `k` true entries. `weightedSum` adds the selected values. `SameHalfSums` supplies functions between all valid masks, inverse equations in both directions, and preservation of each weighted sum. Its witnesses are the complement map, which is its own inverse. Thus it represents equality with multiplicities by a bijection, rather than merely equality of the sets of attainable sums.

The connection to ordinary subsets is proved: `selected_sublist`, `selected_length`, and `selected_sum` give the selected entries, their cardinality, and their ordinary sum. When the original entries are distinct, `mask_representation` proves that every $k$-element sublist is represented by exactly one mask. `ExactSubsetEncoding` packages both directions. Sublists in the inherited order give a canonical list representation of subsets of a list with no duplicates.

In the separate concrete module, `triples_complete` and `triples_nodup` prove that each increasing index triple appears exactly once. `tripleSums` retains repeated values, and `SameTripleSums` is `List.Perm`. `counterexamples`, `different_translations`, and `arbitrarily_large_counterexamples` establish the translated family and its stated bounds.

## Reproduce the checks

The toolchain is pinned to **Lean 4.19.0** in [lean-toolchain](lean-toolchain). The sources depend only on the bundled standard library and the local modules; Mathlib is not required. From this directory, run:

```text
python verify.py --lean lean --receipt verification.json
```

An explicit Lean executable path may be passed to `--lean`. The [script](verify.py) uses Python's standard library, pins the toolchain selection, copies all four sources into a fresh temporary directory, and compiles them in dependency order with warnings treated as errors. It checks all fifteen expected axiom reports. The [receipt](verification.json) records the compiler version, each source's hash, per-module output and status, and the audit results.

Alternatively, with Lean's toolchain manager and Lake installed:

```text
lake build
```

This builds both endpoints and their supporting modules with the pinned toolchain. It does not run the additional receipt-generation checks in `verify.py`.

The supplied receipt records successful compilation of all four files and successful axiom audits. The audited dependencies are confined to Lean's standard foundational axioms, `propext`, `Classical.choice`, and `Quot.sound`. The four source files contain no `sorry`/`admit` placeholders, custom axiom declarations, `native_decide`, or `unsafe` declarations. They are not claimed to have zero axiom dependencies.

The [six-element review](independent-combinatorial-review.md) applies to the unchanged concrete source hash recorded there. The [general proof review](general-independent-review.md) covers the construction, generic reflection proof, and combined endpoint. These are internal cross-checks by separate agents within the same assistant and tool environment, using the same Lean distribution and kernel. They are not independent human peer review, an independently implemented checker, or official prize verification. The work was prepared with OpenAI Codex assistance.

The packet has not yet been independently archived. No designated verifier signatures, committee decision, recipient confirmation, or award record is supplied.

## Scope and earlier work

The half-size obstruction is classical mathematics and has the prior Lean proof prominently linked above. The contribution here is an independently written implementation with explicit positive-integer witnesses, only standard-library dependencies, a separately checked concrete certificate, and reproducible verification records.

For each fixed $k>2$, the sufficiently-large-$n$ uniqueness theorem was proved by Gordon, Fraenkel, and Straus in 1962. The present general family has $n=2k$ with both parameters varying; it does not contradict or formalize that theorem. The translated six-element family makes the values arbitrarily large without increasing its cardinality.

[Existing prize issue 330](https://github.com/TheJustinSunPrize/awards/issues/330) concerns the different $k=n-1$ case. Its presence does not establish novelty for the half-size case: the earlier general proof in hjyuh's repository must also be considered. Please assess this packet as community evidence at its stated scope, without inferring a complete formalization of every formulation collected under the problem entry.

### References

1. J. L. Selfridge and E. G. Straus, *On the determination of numbers by their sums of a fixed order*, Pacific Journal of Mathematics 8 (1958), 847–856, Theorem 3, pp. 850–851. [Primary paper](https://msp.org/pjm/1958/8-4/pjm-v8-n4-p17-s.pdf).
2. B. Gordon, A. S. Fraenkel, and E. G. Straus, *On the determination of sets by the sets of sums of a certain order*, Pacific Journal of Mathematics 12 (1962), 187–196, Section 4. [Primary paper](https://msp.org/pjm/1962/12-1/pjm-v12-n1-p17-s.pdf).
3. hjyuh, `erdos_494.variants.card_eq_2k`, commit `e0da6ec78953b17618895a093d4bee90fd3f6f67`, 12 March 2026. [Pinned prior Lean proof](https://github.com/hjyuh/formal-conjectures/blob/e0da6ec78953b17618895a093d4bee90fd3f6f67/FormalConjectures/ErdosProblems/494.lean#L916); [upstream proof-link registration and build statement](https://github.com/google-deepmind/formal-conjectures/pull/3525).
4. [Erdős problem 494](https://www.erdosproblems.com/494) and [its statement and references](https://www.erdosproblems.com/latex/494).

## License

The newly written Lean sources, verification script, and build configuration are licensed under [MIT](LICENSE). Prose and review/verification records are under [CC BY 4.0](LICENSE-CONTENT), consistent with the parent repository's content license. Cited third-party works retain their original rights; no third-party proof source is included.
