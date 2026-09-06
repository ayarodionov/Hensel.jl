# Hensel

[![CI](https://github.com/ayarodionov/Hensel.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/ayarodionov/Hensel.jl/actions/workflows/CI.yml)

Julia code for playing with functions using Hensel code and Mahler expansion.

A fresh package combining the source of two previously separate projects, kept as
distinct files under `src/`:
- `src/Hensel.jl` — the `Hensel` module: maps real numbers on `[a,b]` to Hensel
  (p-adic digit) codes and back, plus `LinMap`/`FunEnv`/`MahEnv` wrappers for
  approximating real functions as integer functions.
- `src/Mahler.jl` — the `Mahler` submodule (`included` by `Hensel.jl`): Mahler
  expansion of a function (`mexpansion`, `mcoeff`, `mval`) plus supporting
  combinatorics (`bin`, `fac`, `mfill`).
- `src/VanDerPut.jl` — the `VanDerPut` submodule: the van der Put expansion of a
  function (`vpcoeff`, `vpexpansion`, `vpval`), plus p=2 (bitwise) specialisations
  `vp2coeff`, `vp2expansion`, `vp2val`.

`using Hensel` brings in `Hensel`, `Hensel.Mahler`, and `Hensel.VanDerPut`
(all re-exported), no separate package dependencies required for those.

Most functions have a p=2 specialisation (suffixed `2`) that swaps base-p integer
arithmetic (`%`, `÷`, `*`) for bit operations (`&`, `>>`, `<<`): `pIndex2`/`hVector2`/
`iValue2`/`rValue2`, `LinMap2`/`FunEnv2`/`MahEnv2`, and the `VanDerPut` p=2 functions
above. `VpEnv` is a van der Put analogue of `MahEnv`.

`rmencode(msg, r, m)` encodes a message (as a non-negative integer) with the
Reed-Muller RM(r,m) code from the registered `ReedMuller` package, returning the
codeword as a non-negative integer; `rmvpexpansion(r, m)` computes the van der Put
(p=2) expansion of that encoding function over all representable messages.
