#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------
# digitlength / nminus
#--------------------------------------------------------------------------------------------------

@test Hensel.VanDerPut.digitlength(0, 2)  == 0
@test Hensel.VanDerPut.digitlength(1, 2)  == 1
@test Hensel.VanDerPut.digitlength(7, 2)  == 3
@test Hensel.VanDerPut.digitlength(8, 2)  == 4
@test Hensel.VanDerPut.digitlength(9, 10) == 1
@test Hensel.VanDerPut.digitlength(10,10) == 2

@test Mahler === Hensel.Mahler  # sanity: submodules coexist under Hensel

@test VanDerPut.nminus(1, 2) == 0
@test VanDerPut.nminus(5, 2) == 1   # 5 = 101b -> drop leading 1 -> 01b = 1
@test VanDerPut.nminus(7, 2) == 3   # 7 = 111b -> 11b = 3
@test VanDerPut.nminus(23,10) == 3
@test VanDerPut.nminus(230,10) == 30

#--------------------------------------------------------------------------------------------------
# vpcoeff / vpexpansion / vpval: exact reconstruction for arbitrary functions
#--------------------------------------------------------------------------------------------------

p  = 2
sz = 4
for f in ((x) -> x, (x) -> x^2, (x) -> 3*x + 1, (x) -> iseven(x) ? 1 : -1)
    v = VanDerPut.vpexpansion(f, p, sz)
    @test length(v) == p^sz
    for x = 0:(p^sz - 1)
        @test VanDerPut.vpval(x, v, p, sz) == f(x)
    end
end

p10  = 10
sz10 = 2
v10 = VanDerPut.vpexpansion((x) -> x, p10, sz10)
for x = 0:(p10^sz10 - 1)
    @test VanDerPut.vpval(x, v10, p10, sz10) == x
end

#--------------------------------------------------------------------------------------------------
# vpval with fewer digits approximates using a coarser ball
#--------------------------------------------------------------------------------------------------

f = (x) -> x
v = VanDerPut.vpexpansion(f, 2, 4)
for x = 0:15
    @test VanDerPut.vpval(x, v, 2, 1) == f(x % 2)
    @test VanDerPut.vpval(x, v, 2, 2) == f(x % 4)
end

#--------------------------------------------------------------------------------------------------
# p = 2 specialisation: nminus2 / vp2coeff / vp2expansion / vp2val agree with the generic p=2 versions
#--------------------------------------------------------------------------------------------------

for n = 1:31
    @test VanDerPut.nminus2(n) == VanDerPut.nminus(n, 2)
end

sz2 = 5
for f in ((x) -> x, (x) -> x^2, (x) -> 3*x + 1, (x) -> iseven(x) ? 1 : -1)
    v_gen = VanDerPut.vpexpansion(f, 2, sz2)
    v_2   = VanDerPut.vp2expansion(f, sz2)
    @test v_2 == v_gen
    for x = 0:(2^sz2 - 1)
        @test VanDerPut.vp2val(x, v_2, sz2) == f(x)
        for k = 1:sz2
            @test VanDerPut.vp2val(x, v_2, k) == VanDerPut.vpval(x, v_gen, 2, k)
        end
    end
end

#--------------------------------------------------------------------------------------------------
