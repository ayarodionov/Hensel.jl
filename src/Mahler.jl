"Collection of functions for Mahler expansion"
module Mahler
export bin, fac, mfill, mcoeff, mexpansion, mval

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

end # module

# include("./src/Mahler.jl")
# or
# pkg> activate .
# and then
# using Mahler

