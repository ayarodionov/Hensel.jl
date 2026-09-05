#--------------------------------------------------------------------------------------------------
"Collection of functions for mapping Number numbers to Hensel code."
#--------------------------------------------------------------------------------------------------
module Hensel
include("Mahler.jl")
using .Mahler
include("VanDerPut.jl")
using .VanDerPut
export pIndex, hVector, Mahler, VanDerPut

#--------------------------------------------------------------------------------------------------
# Linear mapping 
#--------------------------------------------------------------------------------------------------
"Linear mapping x ∈ [a,b] to y ∈ [0,1]. ."
to01(x::Number, a::Number, b::Number)::Number             = (x-a)/(b-a)
to01(x::Number, (a,b)::Tuple{<:Number, <:Number})::Number = (x-a)/(b-a)

"Linear mapping x ∈ [0,1] to y ∈ [a,b]."
from01(x::Number, a::Number, b::Number)::Number              = x*(b-a)+a
from01(x::Number, (a, b)::Tuple{<:Number, <:Number})::Number = x*(b-a)+a

#--------------------------------------------------------------------------------------------------
# Functions on [a,b]
#--------------------------------------------------------------------------------------------------

"Caclulates Hensel code as integer vector. p is p-adic base, sz - precision.
Asserts: x ∈ [a,b], p > 0, sz > 0."
function hVector(x::Number, a::Number, b::Number, p::Integer, sz::Integer)::Vector{Integer}
    @assert(a <= x <= b)
    return hVector(to01(x, a, b), p, sz)
end

hVector(x::Number, (a, b)::Tuple{<:Real, <:Real}, p::Integer, sz::Integer)::Vector{Integer} = 
    hVector(x, a, b, p, sz)

"Calculates integer from real number x∈[a,b]"
iValue(x::Number, ab::Tuple{<:Number, <:Number}, p::Integer, sz::Integer)::Integer = 
    iValue(hVector(x, ab, p, sz), p)

"Calculates real number x∈[a,b] from integer"
rValue(n::Integer, p::Integer, sz::Integer, ab::Tuple{<:Number, <:Number})::Number = 
    from01(rValue(hVector(n, p, sz), p), ab)

#--------------------------------------------------------------------------------------------------
# Functions on [0,1]
#--------------------------------------------------------------------------------------------------

"Calculates real number x∈[0,1] from Hensel code vector: Σv[i]*p^(-i)/p"
rValue(v::Vector{<:Integer}, p::Integer)::Real = 
    foldl((s,i) -> v[i]+s/p, length(v):-1:1, init = p/2)/p

"Calculates real number x∈[0,1] from integer"
rValue(n::Integer, p::Integer, sz::Integer)::Real = rValue(hVector(n, p, sz), p)

"Suppose [0,1] is diveded into p inervals of equal length. 
Function retuns index of the interval to which x belongs to. 
Indexation starts from 0 (zero). x ∈ [0,1]."
pIndex(x::Number, p::Integer)::Integer = floor(Int, x*p)

"Caclulates Hensel code as integer vector. p is a base, sz - precision.
Asserts: x ∈ [0,1], p > 1, sz > 0."
function hVector(x::Number, p::Integer, sz::Integer)::Vector{Integer}
    @assert(0 <= x <= 1)
    @assert(p > 1)
    @assert(sz > 0)
    if x == 1.0 
        return fill(p - 1, sz)
    end
    h = Vector{Integer}(undef, sz)
    for i = 1 : sz
        n = pIndex(x, p)
        x = to01(x, n/p, (n+1)/p)
        h[i] = n
    end
    return h
end

"Calculates Hensel code vector back from its integer representation"
function hVector(n::Integer, p::Integer, sz::Integer)::Vector{Integer}
    h = Vector{Integer}(undef, sz)
    for i = 1 : sz
        h[i] = n % p
        n ÷= p
    end
    return h
end

"Calculates integer from Hensel code vector: Σv[i]*p^i"
iValue(v::Vector{<:Integer}, p::Integer)::Integer = 
    foldl((s,i) -> v[i]+s*p, length(v):-1:1, init = 0)

#--------------------------------------------------------------------------------------------------
# Abstruct type
#--------------------------------------------------------------------------------------------------
abstract type AbstractMapping end 

#--------------------------------------------------------------------------------------------------
# LinMap
#--------------------------------------------------------------------------------------------------
"Linear mapper integer or hensel code to interval and back"
struct LinMap{T<:Number} <: AbstractMapping 
    ab::Tuple{T, T}     # interval
    p::Integer          # p-adic base
    sz::Integer         # p-adic precision 
end

"Maps integer to point in [a,b]"
(s::LinMap)(n::Integer) = rValue(n, s.p, s.sz, s.ab)

"Maps hensel code to point in [a,b]"
(s::LinMap)(v::Vector{<:Integer}) = from01(rValue(v, s.p), s.ab)

"Maps x∈[a,b] to integer"
# (s::LinMap)(x::Number)::Integer = iValue(x, s.ab, s.p, s.sz)

"Maps x∈[a,b] to integer, hensel code (integer vector), rational or real number"
function (s::LinMap)(x::Number; return_type::String="integer")
    if return_type == "integer"
        return iValue(x, s.ab, s.p, s.sz)
    elseif return_type == "hensel"
        return hVector(x, s.ab, s.p, s.sz)
    elseif return_type == "rational"
        return Rational(x)
    elseif return_type == "real"
        return x
    end
    throw(DomainError(return_type, "unknown keyword"))
end

#--------------------------------------------------------------------------------------------------
# FunEnv
#--------------------------------------------------------------------------------------------------
"Envelope for calculating functions real -> real as integer -> integer"
struct FunEnv{T1<:AbstractMapping, T2<:AbstractMapping}
    f::Function         # function
    marg::T1            # argument map
    mval::T2            # value map
end
FunEnv(f, arange, ap, asz, vrange, vp, vsz) = FunEnv(f, LinMap(arange, ap, asz), LinMap(vrange, vp, vsz))
FunEnv(f, arange, ap, asz, vrange) = FunEnv(f, arange, ap, asz, vrange, ap, asz)
FunEnv(f, arange, ap, asz) = FunEnv(f, arange, ap, asz, arange)

"Direct call to the function"
(s::FunEnv)(x::Real) = s.f(x)

"Call function real -> real as integer -> [integer | vector | real | rational]"
(s::FunEnv)(x::Integer; return_type::String="integer") =
    s.mval(s.f(s.marg(x)), return_type=return_type)

"Call function real, integer -> real as integer -> [integer | vector | real | rational]"
(s::FunEnv)(x::Integer, i::Integer; return_type::String="integer") =
    s.mval(s.f(s.marg(x), i), return_type=return_type)

(s::FunEnv)((x, i, return_type)::Tuple{Integer, Integer, String}) = 
    (s::FunEnv)(x, i, return_type=return_type)

(s::FunEnv)((x, i)::Tuple{Integer, Integer}) = (s::FunEnv)(x, i, return_type="integer")

"For testing how good FunEnv approximates its function"
δ(fe::FunEnv, x::Real) = fe(x) - fe(fe.marg(x), return_type="real")
δ(x::Real, fe::FunEnv) = fe.mval(fe(x)) - fe(fe.marg(x))

#--------------------------------------------------------------------------------------------------
# MahEnv
#--------------------------------------------------------------------------------------------------
"Calculates Mahler expansion of function f of length n"
mexpansion(fe::FunEnv, n::Integer)::Vector = Mahler.mexpansion((x) -> fe(x), n)

"Envelope for Mahler expansion"
struct MahEnv
    fe::FunEnv          # mapping function to integer                 
    mv::Vector          # vector of Mahler coefficients
end
MahEnv(fe::FunEnv) = MahEnv(fe, mexpansion(fe, fe.marg.sz))
MahEnv(fe::FunEnv, n::Integer) = MahEnv(fe, mexpansion(fe, n))

"Calulation from Mahler expansion"
(s::MahEnv)(n::Integer) = Mahler.mval(n, s.mv)
(s::MahEnv)(n::Integer, m::Integer) = Mahler.mval(n, s.mv, m)
"Optional calculation - can use Mahler, extension of FunEnv call"
function (s::MahEnv)(n::Integer, option::String)
    if option == "Mahler"
        return Mahler.mval(n, s.mv)
    elseif option == "Hensel"
        return (s.fe)(n)
    end
    throw(DomainError(option, "unknown keyword"))
end

(s::MahEnv)(x::Real) = Mahler.mval(s.fe.marg(x), s.mv)
(s::MahEnv)(x::Real, m::Integer) = Mahler.mval(s.fe.marg(x), s.mv, m)


δ(se::MahEnv, n::Integer) = (se)(n) - (se)(n, "Hensel")
δ(se::MahEnv, n::Integer, k::Integer) = (se)(n, k) - (se)(n, "Hensel")


#--------------------------------------------------------------------------------------------------
# Additional functions
#--------------------------------------------------------------------------------------------------

"Logistic map function. x∈[0,1]. For testing. 
See <a href=https://en.wikipedia.org/wiki/Logistic_map>Logistic map</a>"
logistic(x::Real, r::Real)::Real = r*x*(1.0 - x)
"n-th iteration of logictic function"
logistic(x::Real, r::Real, n::Integer)::Real = foldl((s,i) -> logistic(s,r), 0:(n-1), init=x)

"Dyadic transformation. x∈[0,1] For testing. 
See <a href=https://en.wikipedia.org/wiki/Dyadic_transformation>Dyadic transformation</a>"
dyadic(x::Real)::Real = mod(2*x, 1)
"n-th iteration of dyadic function"
dyadic(x::Real, n::Integer)::Real = foldl((s,i) -> dyadic(s), 0:(n-1), init=x)

"nyadic transformation. x∈[0,1] For testing."
nyadic(x::Real, n::Integer)::Real = mod(n*x, 1)
"k-th iteration of dyadic function"
nyadic(x::Real, n::Integer, k::Integer)::Real = foldl((s,i) -> nyadic(s, n), 0:(k-1), init=x)

"Shift operator for continued fractions. x∈[0,1]
See <a href=http://www.linas.org/math/gkw.pdf>THE GAUSS-KUZMIN-WIRSING OPERATOR</a>"
cfshift(x::Real)::Real = 1/x - floor(1/x)
"n-th iteration of shift operator for continued fractions"
cfshift(x::Real, n::Integer)::Real = foldl((s,i) -> cfshift(s), 0:(n-1), init=x)

end # module

#--------------------------------------------------------------------------------------------------

# include("./src/Hensel.jl")
# or
# pkg> activate .
# and then
# using Hensel

#--------------------------------------------------------------------------------------------------
