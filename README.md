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

`rmhvector(msg, r, m)` encodes a message (as a non-negative integer) with the
Reed-Muller RM(r,m) code from the registered `ReedMuller` package, returning the
codeword as a Hensel code vector; `rmencode(msg, r, m)` returns the same codeword
packed into an integer (`iValue2(rmhvector(msg, r, m))`) — mirroring how `hVector`/
`iValue` give the vector and integer forms of a p-adic representation. `rmvpexpansion(r, m)`
and `rmmexpansion(r, m)` compute the van der Put (p=2) and Mahler expansions,
respectively, of the message -> codeword-integer function over all representable
messages (note: `rmmexpansion` is O(n²) with BigInt binomials, so it's only
practical for small RM(r,m)).

`rmdecode(codeword, r, m)` inverts `rmencode`/`rmhvector` (codeword as an integer or
a Hensel code vector) back to the message integer. It's exact GF(2) linear algebra
(RM(r,m) is a linear code: `rmhvector` is GF(2)-linear in the message bits, so
decoding a valid codeword is solving `msg*G = codeword` by inverting an information
set of the generator matrix), not a Hensel-lifting search — a digit-by-digit lift
was tried first, but RM(r,m) is a rate k/n < 1 code (`k = dimension(RMCode(r,m))
< n = 2^m`), so a truncated prefix of the (redundant) codeword doesn't carry enough
information to pin down the next message bit uniquely; see the comment above
`rmdecode` in `src/Hensel.jl` for the worked-out reason.
