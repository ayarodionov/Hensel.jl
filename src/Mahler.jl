"Collection of functions for Mahler expansion"
module Mahler
export bin, fac, mfill, mcoeff, mexpansion, mval
export bin2, mcoeff2, mexpansion2, mval2

"Returns +1 for even and -1 for odd numbers"
sgn(n::Integer)::Integer = n % 2 == 0 ? 1 : -1

"Factorial. Automatically switches from factorial(n) to factorial(big(n))"
fac(n::Integer)::Integer = n < 21 ? factorial(n) : factorial(big(n))

"Binomial coefficient. Automatically switches from binomial(n,k) to binomial(big(n),big(k))"
bin(n::Integer, k::Integer)::Integer = (n+k) < 96 ? binomial(n,k) : Base.binomial(big(n),big(k))

"Binomial coefficient with Real first argument"
bin(x::Real, k::Integer)::Real = prod((i) -> x-i, 0:(k-1), init=1.0)/fac(k)

"Creates vector of values of function f in the first n integers"
mfill(f::Function, n::Integer)::Vector = f.(collect(0:(n-1)))

"Calculates Mahler coefficient from vector v"
mcoeff(v::Vector)::Number = mcoeff(v, length(v))

"Calculates Mahler coefficient from the first n+1 elements of vector v,; n=0,1,2,..."
mcoeff(v::Vector, n::Integer)::Number = sum((k) -> sgn(n-k)*bin(n,k)*v[k+1], 0:n, init=0)

"Calculates the n-th Mahler coefficient of function f"
mcoeff(f::Function, n::Integer)::Number = mcoeff(f.(collect(0:n)))

"Calculates Mahler expansion of function f of length n"
mexpansion(f::Function, n::Integer)::Vector = mexpansion(f.(collect(0:(n-1))))

"Calculates Mahler expansion of a function values stored in vector v"
mexpansion(v::Vector)::Vector = mexpansion(v, length(v))

"Calculates Mahler expansion of length n of a function values stored in vector v"
mexpansion(v::Vector, n::Integer)::Vector = ((i) -> mcoeff(v, i)).(collect(0:(n-1)))

"Calculates value of function represented as a vector of Mahler coefficients"
mval(x::Number, v::Vector)::Number = mval(x, v, length(v))

"Calculates value of function represented as a vector of Mahler coefficients; uses only first n coefficients"
mval(x::Number, v::Vector, n::Integer)::Number = sum((k) -> bin(x,k)*v[k+1], 0:(n-1), init=0)

# Some functions
"p-adic logarithm"
lnp(x::Real, k::Integer)::Real = sum((n) -> sgn(n+1)*(x-1)^n/n, 1:k, init=0.0)
lnp(x::Real)::Real = Base.log(x)

#--------------------------------------------------------------------------------------------------
# p = 2 specialisation: coefficients and values are taken mod 2 (GF(2)). Lucas' theorem replaces
# fac/binomial ((n+k) < 96 ? binomial(n,k) : big binomial) with a single bitwise AND, and the
# alternating sum collapses to XOR since sgn(n) ≡ 1 (mod 2).
#--------------------------------------------------------------------------------------------------

"Lucas' theorem for p=2: binomial(n,k) is odd iff every set bit of k is also set in n"
bin2(n::Integer, k::Integer)::Bool = (k & n) == k

"Calculates value mod 2 of a function represented as a vector of Mahler coefficients mod 2;
uses only the first n coefficients"
mval2(x::Integer, v::Vector{<:Integer}, n::Integer)::Integer =
    reduce(⊻, (v[k+1] for k = 0:(n-1) if bin2(x, k)); init = 0)

"Calculates value mod 2 of a function represented as a vector of Mahler coefficients mod 2"
mval2(x::Integer, v::Vector{<:Integer})::Integer = mval2(x, v, length(v))

"Calculates the n-th Mahler coefficient mod 2 from a vector v of function values (mod 2)"
mcoeff2(v::Vector{<:Integer}, n::Integer)::Integer = mval2(n, v, n+1)

"Calculates the last Mahler coefficient mod 2 of vector v"
mcoeff2(v::Vector{<:Integer})::Integer = mcoeff2(v, length(v)-1)

"Calculates Mahler expansion mod 2 of length n of a vector v of function values (mod 2)"
mexpansion2(v::Vector{<:Integer}, n::Integer)::Vector{Integer} = ((i) -> mcoeff2(v, i)).(collect(0:(n-1)))

"Calculates Mahler expansion mod 2 of a vector v of function values (mod 2)"
mexpansion2(v::Vector{<:Integer})::Vector{Integer} = mexpansion2(v, length(v))

"Calculates Mahler expansion mod 2 of function f of length n"
mexpansion2(f::Function, n::Integer)::Vector{Integer} = mexpansion2(mod.(f.(collect(0:(n-1))), 2), n)

end # module

# include("./src/Mahler.jl")
# or
# pkg> activate .
# and then
# using Mahler

