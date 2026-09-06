#--------------------------------------------------------------------------------------------------
# Reed-Muller encoding / van der Put expansion tests
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------
# rmencode agrees with a direct ReedMuller.jl call
#--------------------------------------------------------------------------------------------------

for (r, m) in ((1, 3), (1, 4), (2, 4))
    code = RMCode(r, m)
    k = dimension(code)
    n = blocklength(code)
    @test n == 2^m

    enc = MatrixEncoder(code)
    for msg = 0:(2^k - 1)
        msgvec = Bool.(Hensel.hVector2(msg, k))
        expected = Hensel.iValue2(Int.(encode(enc, code, msgvec)))
        @test Hensel.rmencode(msg, r, m) == expected
    end
end

@test_throws AssertionError Hensel.rmencode(-1, 1, 3)
@test_throws AssertionError Hensel.rmencode(16, 1, 3)   # k=4 => valid range is 0:15

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
