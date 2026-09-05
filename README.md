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

`using Hensel` brings in both `Hensel` and `Hensel.Mahler` (re-exported), no
separate `Mahler` package dependency required.
