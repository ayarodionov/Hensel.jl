#--------------------------------------------------------------------------------------------------
# p = 2 specialisation tests
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------
# pIndex2 / hVector2 / iValue2 / rValue2 on [0,1] agree with the generic p=2 versions
#--------------------------------------------------------------------------------------------------

for x in [0.0, 0.005, 0.1, 0.2, 0.3, 0.499, 0.5, 0.699999, 0.9, 0.999, 1.0]
    @test Hensel.pIndex2(x) == Hensel.pIndex(x, 2)
end

sz = 8
for x in [0.0, 0.005, 0.1, 0.2, 0.3, 0.499, 0.5, 0.699999, 0.9, 0.999, 1.0]
    @test Hensel.hVector2(x, sz) == Hensel.hVector(x, 2, sz)
end

for n = 0:(2^sz - 1)
    @test Hensel.hVector2(n, sz) == Hensel.hVector(n, 2, sz)
end

for v in ([0,0,0], [1,0,0], [0,1,0], [1,1,0], [1,1,1], [0,0,1])
    @test Hensel.iValue2(v) == Hensel.iValue(v, 2)
    @test Hensel.rValue2(v) == Hensel.rValue(v, 2)
end

for n = 0:(2^sz - 1)
    @test Hensel.rValue2(n, sz) == Hensel.rValue(n, 2, sz)
end

#--------------------------------------------------------------------------------------------------
# on [a,b] agree with the generic p=2 versions
#--------------------------------------------------------------------------------------------------

@test Hensel.hVector2(11.5, 11, 12, 3)    == Hensel.hVector(11.5, 11, 12, 2, 3)
@test Hensel.hVector2(0.0, -1.0, 1.0, 3)  == Hensel.hVector(0.0, -1.0, 1.0, 2, 3)
@test Hensel.hVector2(-0.9, -1.0, 1.0, 3) == Hensel.hVector(-0.9, -1.0, 1.0, 2, 3)
@test Hensel.hVector2(100.3, 100, 101, 3) == Hensel.hVector(100.3, 100, 101, 2, 3)
@test Hensel.hVector2(11.5, (11, 12), 3)  == Hensel.hVector(11.5, (11, 12), 2, 3)

@test Hensel.iValue2(11.5, (11, 12), sz) == Hensel.iValue(11.5, (11, 12), 2, sz)
@test Hensel.iValue2(100.3, (100, 101), sz) == Hensel.iValue(100.3, (100, 101), 2, sz)

for n = 0:(2^sz - 1)
    @test Hensel.rValue2(n, sz, (11, 12)) == Hensel.rValue(n, 2, sz, (11, 12))
end

#--------------------------------------------------------------------------------------------------
# roundtrip consistency, mirroring hTest/dTest in functions_on_01_tests.jl
#--------------------------------------------------------------------------------------------------

function h2Test(x, sz)
    @test Hensel.hVector2(Hensel.rValue2(Hensel.hVector2(x, sz)), sz) == Hensel.hVector2(x, sz)
end

h2Test(0.5, 3)
h2Test(0.009, 14)
h2Test(0.333, 14)
h2Test(0.999, 14)

#--------------------------------------------------------------------------------------------------
