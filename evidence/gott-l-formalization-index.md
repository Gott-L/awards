# Gott-L: six scoped Lean formalization contributions

This evidence submission gathers six completed formal results across five catalogue entries. Each packet preserves its exact theorem, prior-work disclosures, pinned dependencies, fresh verification record and reproduction instructions. The requested assessment concerns the actual formalization contributions. No packet is presented as resolving every formulation of its broader catalogue problem.

## Contributions and exact boundaries

| Catalogue entry | Completed result | Scope remaining outside this packet | Evidence |
| --- | --- | --- | --- |
| JSP-000399 / Erdős 494 | A five-parameter 27-form triple-sum reflection identity and a checked distinct-positive-integer specialization | General eventual reconstruction and first priority for the already formalized fixed existence result | [Proof and checks](jsp-000399-parametric-27/README.md) |
| JSP-000883 / Erdős 1063 | For all n ≥ k ≥ 2, at least one n−i with i<k does not divide choose(n,k), including the exact registered exists_exception variant | Least-starting-point asymptotic bounds are outside this particular packet | [Proof and checks](jsp-000883-exists-exception/README.md) |
| JSP-000737 / Erdős 886 | The complete known infinite four-divisor construction at C=16, and C=9 for the same family, with strict real interval endpoints | The main universal upper-bound question and global optimality of constants | [Proof and checks](jsp-000737-rosenfeld-16-9/README.md) |
| JSP-000295 / Erdős 357 | The complete known infinite-sequence lower-density-zero theorem with the original global distinct-consecutive-sums hypothesis | Full density zero, reciprocal-series convergence and the finite extremal conjecture | [Proof and checks](jsp-000295-lower-density/README.md) |
| JSP-000904 / Erdős 1087 | Exact equal-distance four-point counting identities, the universal planar comparison F≤W≤10F, and an exact four-point example attaining 10 | The original open asymptotic exponent, general isosceles bounds, and the external analytic estimates | [Proof and checks](jsp-000904-distance-counting/README.md) |
| JSP-000883 / Erdős 1063, additional endpoint | For every ε>0, eventually an actual unique-exception witness satisfies n≤exp(εk); the actual minimum has log(n_k)=o(k) and log(n_k)/k→0 | Sharp growth order, exact values, mathematical discovery, and priority for the improved-upper target already formalized in PR601 | [Proof and checks](jsp-000883-subexponential/README.md) |

The 94 file blobs in the first five evidence packets remain unchanged. The sixth packet adds 30 files, and this index records the expanded scope. Each mathematical package is reproducible separately. No catalogue, candidate, award, recipient-confirmation or payment record is changed.

## Review request and prior work

Please assess these formalization contributions under the [official selection rules](https://www.hejustinsun.com/prize/rules), including the community-contribution and partial-progress provisions where applicable. The request does not presume a tier, eligibility decision, first-priority finding, or payment allocation. Repository publication and local checks do not substitute for official verification and adjudication.

The related submissions, original mathematical authors and reused code are identified in each packet. The bounded source searches distinguish these particular endpoints from prior examples or other variants; they are not global priority certificates. The fixed 27-element existence result already has a public Lean proof; the C64 precursor to the four-divisor construction retains its MIT notice; and the fifth packet formalizes the credited finite-counting argument in [haipapa123's PR586](https://github.com/TheJustinSunPrize/awards/pull/586).

For the sixth packet, the subexponential mathematics is already public in Patrick White's and Ricky Cipollini's related work. [56647563's PR601](https://github.com/TheJustinSunPrize/awards/pull/601) already formalizes the improved-upper target at a fixed positive exponential rate. Its licensed finite proof is explicitly reused and credited. The additional formalization extends the parameter to an arbitrary root degree chosen after ε, proving the stronger quantified subexponential endpoint. Source-access limits and reuse are disclosed in that packet.

## Verification

The six packets contain thirty-four proof modules. Their recorded fresh compilations and per-packet axiom audits all passed: respectively 18, 10, 28, 20, 54 and 86 named declaration checks. Only standard logical axioms are permitted. Each package records its own exact statement checks and source hashes; five packages use the pinned Mathlib 4.19 dependency cache and the first uses bundled Std.

The fifth packet also passed a separate fresh replay by a same-team agent that did not write its seven proof modules: fifteen independently transcribed statements and 93 named audits. Its T is explicitly encoded as unordered pairs of equal edges sharing a unique vertex.

The sixth packet passed ten primary statement checks and a separate fresh replay of all eleven modules, twelve independently transcribed statements and 98 named audits. Its reviewer ported the inherited finite modules but did not write the new prime-count, parameter, asymptotic or minimum proofs. The checks verify actual witnesses, nonemptiness, the literal natural infimum and the order of quantifiers in the subexponential conclusion.

Internal reviews disclose the reviewers' participation in development. They are not official verification, independent human review, or separate implementations of the Lean kernel. Pinned dependency-cache trust is disclosed. Earlier packets' sources and internal evidence remain unchanged.

## Attribution

Gott-L proposed and initiated the project, set the objectives, planning and research direction, and authorizes this submission. OpenAI Codex provided candidate research, proof reconstruction and extension, formal implementation, documentation and internal checks under Gott-L's instructions. Historical mathematical discoveries and prior formalizations retain their named attribution. Project planning is not presented as authorship of earlier mathematical discoveries.

## Immutable packet history

- JSP-000399: [dfedecd53e4daa41151a35692b90d98defe3a8d6](https://github.com/Gott-L/awards/commit/dfedecd53e4daa41151a35692b90d98defe3a8d6).
- JSP-000883, universal nondivisor: [02751f6f848b4536c87cba551f69635c36013f47](https://github.com/Gott-L/awards/commit/02751f6f848b4536c87cba551f69635c36013f47).
- JSP-000737: [0f5b94d8c3d5b00c21ce1ffb8a8a87c886e6687f](https://github.com/Gott-L/awards/commit/0f5b94d8c3d5b00c21ce1ffb8a8a87c886e6687f).
- JSP-000295: [315bc08f5706630f025410330c3ce66ec27acd82](https://github.com/Gott-L/awards/commit/315bc08f5706630f025410330c3ce66ec27acd82).
- JSP-000904: [b21109ece19bcc8b18b9646567dfc6d5ac088d21](https://github.com/Gott-L/awards/commit/b21109ece19bcc8b18b9646567dfc6d5ac088d21).
- JSP-000883, subexponential upper bound: [0bf84f8331887182b61c878f782072ec6d755db2](https://github.com/Gott-L/awards/commit/0bf84f8331887182b61c878f782072ec6d755db2).

The individual commits remain available for separate review if the maintainers prefer that organization. This index is licensed CC BY 4.0; packet-specific licenses and notices remain unchanged. Private contact, identity and payment details are excluded.
