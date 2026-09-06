#--------------------------------------------------------------------------------------------------
# Reed-Muller encoding (Hensel code and integer forms), van der Put expansion, Mahler expansion
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------
# rmhvector agrees with a direct ReedMuller.jl call; rmencode agrees with iValue2(rmhvector(...))
#--------------------------------------------------------------------------------------------------

for (r, m) in ((1, 3), (1, 4), (2, 4))
    code = RMCode(r, m)
    k = dimension(code)
    n = blocklength(code)
    @test n == 2^m

    enc = MatrixEncoder(code)
    for msg = 0:(2^k - 1)
        msgvec = Bool.(Hensel.hVector2(msg, k))
        expected = Int.(encode(enc, code, msgvec))
        @test Hensel.rmhvector(msg, r, m) == expected
        @test length(Hensel.rmhvector(msg, r, m)) == n
        @test Hensel.rmencode(msg, r, m) == Hensel.iValue2(expected)
    end
end

@test_throws AssertionError Hensel.rmhvector(-1, 1, 3)
@test_throws AssertionError Hensel.rmhvector(16, 1, 3)   # k=4 => valid range is 0:15
@test_throws AssertionError Hensel.rmencode(-1, 1, 3)
@test_throws AssertionError Hensel.rmencode(16, 1, 3)

#--------------------------------------------------------------------------------------------------
# rmvpexpansion: exact reconstruction (van der Put expansion at full precision) and agreement
# with VanDerPut.vp2expansion/vp2val applied directly to rmencode
#--------------------------------------------------------------------------------------------------

for (r, m) in ((1, 3), (1, 4), (2, 4))
    k = dimension(RMCode(r, m))

    v  = Hensel.rmvpexpansion(r, m)
    v2 = VanDerPut.vp2expansion((msg) -> Hensel.rmencode(msg, r, m), k)
    @test v == v2
    @test length(v) == 2^k

    for msg = 0:(2^k - 1)
        @test VanDerPut.vp2val(msg, v, k) == Hensel.rmencode(msg, r, m)
    end
end

#--------------------------------------------------------------------------------------------------
# rmmexpansion: exact reconstruction (Mahler expansion at full precision) and agreement with
# Mahler.mexpansion/mval applied directly to rmencode
#--------------------------------------------------------------------------------------------------

for (r, m) in ((1, 3), (1, 4))   # (2,4) omitted: k=11 => Mahler's O(n^2) BigInt binomials are too slow
    k = dimension(RMCode(r, m))

    mv  = Hensel.rmmexpansion(r, m)
    mv2 = Mahler.mexpansion((msg) -> Hensel.rmencode(msg, r, m), 2^k)
    @test mv == mv2
    @test length(mv) == 2^k

    for msg = 0:(2^k - 1)
        @test Mahler.mval(msg, mv) == Hensel.rmencode(msg, r, m)
    end
end

#--------------------------------------------------------------------------------------------------
