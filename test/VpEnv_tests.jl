#--------------------------------------------------------------------------------------------------
# VpEnv tests
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------

fe = Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5))
ve = Hensel.VpEnv(fe)

@test ve.p == 2
@test ve.sz == 8
@test ve.vv == VanDerPut.vpexpansion((x) -> fe(x), 2, 8)

for n = 0:(2^ve.sz - 1)
    @test ve(n) == VanDerPut.vpval(n, ve.vv, 2, 8)
    @test ve(n) == fe(n)                       # exact at full precision
    @test ve(n, "Hensel") == fe(n)
    @test ve(n, "VanDerPut") == ve(n)
    @test Hensel.δ(ve, n) == 0                 # exact reconstruction => zero error
end

for x in [0.0, 0.1, 0.25, 0.5, 0.75, 0.999]
    @test ve(x) == VanDerPut.vpval(fe.marg(x), ve.vv, 2, 8)
end

@test_throws DomainError ve(0, "bogus")

#--------------------------------------------------------------------------------------------------
# explicit precision constructor and coarser reconstruction
#--------------------------------------------------------------------------------------------------

ve4 = Hensel.VpEnv(fe, 4)
@test ve4.sz == 4
@test ve4.vv == VanDerPut.vpexpansion((x) -> fe(x), 2, 4)

for n = 0:15
    @test ve4(n) == VanDerPut.vpval(n, ve4.vv, 2, 4)
    @test ve(n, 4) == ve4(n)
end

#--------------------------------------------------------------------------------------------------
