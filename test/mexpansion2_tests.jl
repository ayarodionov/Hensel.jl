#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------
# bin2: Lucas' theorem parity check agrees with Mahler.bin(n,k) mod 2
#--------------------------------------------------------------------------------------------------

for n = 0:20, k = 0:20
    @test Mahler.bin2(n, k) == (isodd(Mahler.bin(n, k)))
end

#--------------------------------------------------------------------------------------------------
# mcoeff2 / mexpansion2 / mval2 agree with the generic functions taken mod 2
#--------------------------------------------------------------------------------------------------

n = 12
for f in ((x) -> x, (x) -> x^2, (x) -> 3*x + 1, (x) -> iseven(x) ? 1 : 0, (x) -> x*(x-1)*(x-2))
    v = mod.(f.(collect(0:(n-1))), 2)

    @test Mahler.mexpansion2(f, n) == mod.(Mahler.mexpansion(f, n), 2)
    @test Mahler.mexpansion2(v)    == mod.(Mahler.mexpansion(v), 2)

    e2 = Mahler.mexpansion2(v)
    for i = 0:(n-1)
        @test Mahler.mcoeff2(v, i) == mod(Mahler.mcoeff(v, i), 2)
    end
    for x = 0:(n-1)
        @test Mahler.mval2(x, e2) == v[x+1]              # exact reconstruction at sample points
        @test Mahler.mval2(x, e2) == mod(Mahler.mval(x, Mahler.mexpansion(v)), 2)
    end
end

#--------------------------------------------------------------------------------------------------
