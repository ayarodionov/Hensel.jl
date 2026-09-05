"Collection of functions for van der Put expansion"
module VanDerPut
export nminus, vpcoeff, vpexpansion, vpval

"Number of base-p digits of n (0 for n == 0)"
function digitlength(n::Integer, p::Integer)::Integer
    n == 0 && return 0
    s = 0
    while n > 0
        n ÷= p
        s += 1
    end
    return s
end

"n with its most significant base-p digit removed, i.e. n mod p^(digitlength(n,p)-1).
Asserts: n > 0."
function nminus(n::Integer, p::Integer)::Integer
    @assert(n > 0)
    k = digitlength(n, p)
    return n % p^(k-1)
end

"Calculates the n-th van der Put coefficient of function f: B_0 = f(0), B_n = f(n) - f(n^-)"
vpcoeff(f::Function, n::Integer, p::Integer)::Number = n == 0 ? f(0) : f(n) - f(nminus(n, p))

"Calculates the n-th van der Put coefficient from vector of values v (v[i+1] represents f(i))"
vpcoeff(v::Vector, n::Integer, p::Integer)::Number = n == 0 ? v[1] : v[n+1] - v[nminus(n, p)+1]

"Calculates van der Put expansion of length n of a function values stored in vector v"
vpexpansion(v::Vector, p::Integer)::Vector = ((i) -> vpcoeff(v, i, p)).(collect(0:(length(v)-1)))

"Calculates van der Put expansion of function f over the first p^sz integers"
vpexpansion(f::Function, p::Integer, sz::Integer)::Vector = vpexpansion(f.(collect(0:(p^sz-1))), p)

"Calculates value of function represented as a vector of van der Put coefficients v
at integer x, using the first sz base-p digits of x. Reconstructs f(x mod p^sz) exactly
when v holds the full expansion for that many digits; otherwise approximates it."
function vpval(x::Integer, v::Vector, p::Integer, sz::Integer)::Number
    s = v[1]
    prefix = 0
    xx = x
    for level = 0:(sz-1)
        d = xx % p
        xx ÷= p
        newprefix = prefix + d*p^level
        if newprefix != prefix
            s += v[newprefix+1]
            prefix = newprefix
        end
    end
    return s
end

end # module VanDerPut
