-- Don't use a module for the slides yet: a missing `import all` leads to docstrings
-- not showing up in hovers.

import VersoSlides
import Mathlib

open VersoSlides

set_option verso.code.warnLineLength 500

open Verso Doc Elab in
/-- Highlighted text, styled by the class `highlight` in `custom.css`. -/
@[role]
def highlight : RoleExpanderOf Unit
  | (), stxs => do
    let contents ← stxs.mapM elabInline
    ``(Verso.Doc.Inline.other (VersoSlides.InlineExt.styled #[("class", "highlight")])
        #[$contents,*])

open Verso Doc Elab in
/-- A source reference in small gray text, styled by the class `source` in `custom.css`. -/
@[role]
def source : RoleExpanderOf Unit
  | (), stxs => do
    let contents ← stxs.mapM elabInline
    ``(Verso.Doc.Inline.other (VersoSlides.InlineExt.styled #[("class", "source")])
        #[$contents,*])

/-- The target of a `{footnote}` mark. -/
structure FootnoteConfig where
  /-- The URL that the mark links to. -/
  url : String

open Verso ArgParse in
instance : FromArgs FootnoteConfig Verso.Doc.Elab.DocElabM where
  fromArgs := FootnoteConfig.mk <$> .positional' `url

open Lean Verso Doc Elab in
/-- A footnote mark linking to its argument, small and raised, styled by the class `footnote`
in `custom.css`. Usage: `{footnote "url"}[1]`. -/
@[role]
def footnote : RoleExpanderOf FootnoteConfig
  | { url }, stxs => do
    let contents ← stxs.mapM elabInline
    ``(Verso.Doc.Inline.other (VersoSlides.InlineExt.styled #[("class", "footnote")])
        #[Verso.Doc.Inline.link #[$contents,*] $(quote url)])

open Verso Doc Elab in
/-- Smaller text, styled by the class `small` in `custom.css`. -/
@[role]
def small : RoleExpanderOf Unit
  | (), stxs => do
    let contents ← stxs.mapM elabInline
    ``(Verso.Doc.Inline.other (VersoSlides.InlineExt.styled #[("class", "small")])
        #[$contents,*])

#doc (Slides) "Introduction to Lean and Mathlib" =>

# An overview of Lean

Lua Viana Reis · Universität Bonn

:::notes
Press *S* for the speaker view.
:::

# What is Lean?

* A {highlight}[dependently typed] functional programming language...
* {fragment}[... which is able to verify mathematical proofs {highlight}[(how?)]]
* {fragment}[... with a proof assistant interface {highlight}[(what is that?)]]

::: fragment
For mathematicians, it's like a pedantic friend, who only understands if you justify your proofs down to the axioms.

It also gives you many tools to make that task easier.
:::

# Dependently typed

Roughly: every expression in the language has a type.

To construct or destruct a value of a type, we must obey certain rules of type theory which are checked by the {highlight}[kernel].

:::class "no-output"
```lean -stretch
#check (2 : ℕ)
#check (2 + 2 = 4 : Prop)
#check (by rfl : 2 + 2 = 4)
```
:::

Lean's type theory is roughly equivalent to ZFC + inaccessible cardinals
{small}[([M. Carneiro, _The Type Theory of Lean_, MS thesis, 2019](https://github.com/digama0/lean-type-theory/releases/tag/v1.0))].

# What is Lean?
%%%
backgroundIframe := "https://live.lean-lang.org/#code=import%20Mathlib%0A%0Aexample%20%7BX%20Y%20Z%20%3A%20Type%2A%7D%20%5BTopologicalSpace%20X%5D%20%5BTopologicalSpace%20Y%5D%20%5BTopologicalSpace%20Z%5D%0A%20%20%20%20%28f%20%3A%20X%20%E2%86%92%20Y%29%20%28g%20%3A%20Y%20%E2%86%92%20Z%29%20%28hf%20%3A%20Continuous%20f%29%20%28hg%20%3A%20Continuous%20g%29%20%3A%0A%20%20%20%20Continuous%20%28g%20%E2%88%98%20f%29%20%3A%3D%20by%0A%20%20rw%20%5Bcontinuous_def%5D%20at%20%2A%0A%20%20intro%20U%20hU%0A%20%20exact%20hf%20_%20%28hg%20U%20hU%29%0A"
backgroundInteractive := true
%%%

{class "navigate-next"}[Next slide →]

# What is Lean?

It is not the only proof assistant: there is Rocq, Isabelle, Agda, Metamath and many others.

Lean has caught the attention of the mathematical community for some specialties, such as:
- the biggest (human reviewed) mathematical library, Mathlib;
- some early projects for formalizing advanced mathematics;
- infrastructure for supporting large libraries of mathematics (greatly due to the development being tied to Mathlib);
- a small kernel.

# What is Lean?

It's not new;

* started in 2013 by Leonardo de Moura at Microsoft Research
* 2015: Lean 2
* 2017: Lean 3; the community library Mathlib is started
* 2021: Lean 4, rewritten as a general-purpose programming language, implemented mostly in Lean itself.
* 2023: mathlib ported to Lean 4; first stable version of Lean 4; the Lean FRO is founded to develop Lean.

# Some human formalizations in Lean

* Perfectoid Spaces {small}[([Buzzard, Commelin, Massot; 2020](https://leanprover-community.github.io/lean-perfectoid-spaces/))]
* Liquid Tensor Experiment {small}[([led by Commelin and Topaz; 2022](https://github.com/leanprover-community/lean-liquid))]
* Sphere Eversion {small}[([van Doorn, Massot, Nash; 2023](https://leanprover-community.github.io/sphere-eversion/))]
* Carleson's Theorem {small}[([led by van Doorn; 2025](https://github.com/fpvandoorn/carleson))]
* Sphere Packing {small}[([Birkbeck, Hariharan, Lee, Ma, Mehta, Viazovska; 2026/ongoing](https://github.com/thefundamentaltheor3m/Sphere-Packing-Lean))]
* Fermat's Last Theorem {small}[([led by Buzzard; ongoing](https://github.com/ImperialCollegeLondon/FLT))]

{fragment}[Formalizing by hand can force one to think more carefuly about the mathematics and figure out mistakes or insights.]

# Some AI-generated autoformalizations in Lean

* Jul 2024: 3 IMO problems {small}[([170 LoC](https://storage.googleapis.com/deepmind-media/DeepMind.com/Blog/imo-2024-solutions/index.html))]
* Mar 2026: Sphere packing in 24 dimensions {small}[([200k LoC](https://www.math.inc/sphere-packing))]
* May 2026: Erdős' unit-distance conjecture is false {small}[([1.2M LoC](https://github.com/plby/Erdos90))]
* Sep 2026: Fermat's Last Theorem {small}[([13M LoC](https://www.anthropic.com/research/formalizing-fermats-last-theorem))]
* Oct 2026: Classification of finite simple groups {small}[([43M LoC](https://axiommath.ai/research/the-enormous-theorem-formalized/))]
* Nov 2026: Stacks project {small}[([16M LoC](https://stacks.axiommath.ai/))]

# Some AI-generated autoformalizations in Lean

The huge sizes are often due to bad code quality (≠ correctness), but the recent projects would require an enourmous amount of work to be formalized by hand.

Depending on _how_ the autoformalization is done, there is not much more than one bit of information resulting from it.

# Lean as a "popular" language

:::::hstack
::::vstack
*New GitHub repos per month*

{image "images/github-repos.png" (width := "100%")}[New GitHub repositories per month: Lean and Wolfram Language]
::::
::::vstack
*arXiv papers with Lean per month*

{image "images/arxiv-papers.png" (width := "100%")}[arXiv papers mentioning Lean per month]
::::
:::::

{source}[Sources: GitHub search; [paperswithlean.com](https://paperswithlean.com) (retrieved 10 Nov 2026).
Graphs from F. van Doorn, [_Formalized mathematics in the age of AI_](https://florisvandoorn.com/talks/aimath_2611.pdf), 11 Nov 2026.]

Of those recent research papers using Lean, most formalizations are AI-generated ─ it is now relatively easy to ask AI for that.

{fragment}[Just because a paper includes a Lean proof, that does not mean the paper is correct.]

# What a verified proof means?

* Lean can only check the correctness of a _formal proof_; whether _definitions and statements_ correspond to their informal notions is necessarily an exercise for the reader.
  * {fragment}[Mathlib: reviewed and tested definitions]
  * {fragment}[formal-conjectures (of which ~20% were initially misformalized)]
* {fragment}[Whether a _formal_ proof is a faithful translation of the _informal_ proof is also an exercise for the reader.] 
  * {fragment}[_Navier–Stokes lost in translation_ (Bastounis, Circelli, Hansen; 2026)]

:::notes
Formal-conjectures misformalizations (~20% according to Felix — check the figure).
:::

# Other smaller points

* "Junk values": 1/0 = 0.
  * Not really a problem for proofs, but can result in wrong statements!{footnote "https://xenaproject.wordpress.com/2020/07/05/division-by-zero-in-type-theory-a-faq/"}[1]
* Kernel bugs.
  * Mostly a problem for AI formalizations, which could exploit anything.
  * There are other kernel implementations, one of them with a proof of relative consistency.{footnote "https://github.com/leanprover/con-leche"}[2]

{source}[¹ K. Buzzard, [_Division by zero in type theory: a FAQ_](https://xenaproject.wordpress.com/2020/07/05/division-by-zero-in-type-theory-a-faq/), Xena Project blog, 2020.]
{source}[² J. Breitner et al., [_con-leche: an external Lean checker with a proof of consistency_](https://github.com/leanprover/con-leche), 2026.]


# Comparator

Comparator is a tool for checking trusted code with the definitions and the statement against an untrusted proof of the statement.

It mostly relies on organization, checking the trustworthy statment separately from a possibly cheating proof, which is checked in a sandbox.

Also see [Validating a Lean Proof](https://lean-lang.org/doc/reference/latest/ValidatingProofs) in the language reference.

# Mathlib

Mathlib has now more mathematics than typical undergraduate curriculum.

It does not priorizite extensiveness over other goals: writing theories in their right generality, keeping all areas of math compatible with each other, being maintainable.

Mathlib also provides _metaprogramming_ infrastructure for maths: tactics, linters.

# Mathlib: Examples

```lean -stretch
example (a b : ℝ) :
    a * b ≤ (a ^ 2 + b ^ 2) / 2 := by
  nlinarith [sq_nonneg (a - b)]

example : Continuous fun x : ℝ =>
    Real.exp (x ^ 2) + Real.sin x := by
  fun_prop

example (x : ℝ) (hx : 0 < x) :
    0 < x ^ 3 + Real.sqrt x + 1 := by
  positivity

example (x : ℝ) (hx : 0 < x) :
    0 < Real.exp x := by
  positivity
```

# Learning Lean

[Community website](https://leanprover-community.github.io/learn.html)

* *Books*: _Mathematics in Lean_, _Theorem Proving in Lean 4_, _The Mechanics of Proof_, _Functional Programming in Lean_
* *Games*: the Natural Number Game and others at [adam.math.hhu.de](https://adam.math.hhu.de)
* *Zulip*: [leanprover.zulipchat.com](https://leanprover.zulipchat.com), especially the _new members_ channel

# Why Learn?

* Contribute to Mathlib
* Build a trusted library for your corner of mathematics that other researchers can use
* It's fun! And type theory is a different way to think about mathematics

# Thanks!

Questions

[Live demo](https://live.lean-lang.org/#project=MathlibDemo&codez=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)

(Extra slides next)

# Installing Lean

https://lean-lang.org/install/

