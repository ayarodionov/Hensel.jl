#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------

@test Mahler.sgn(2) == 1
@test Mahler.sgn(7) == -1

@test Mahler.fac(5)  == 120
@test Mahler.fac(20) == factorial(20)
@test Mahler.fac(20) == factorial(big(20))
@test Mahler.fac(21) == factorial(big(21))

@test Mahler.bin(4,3)    == 4
@test Mahler.bin(3,4)    == 0
@test Mahler.bin(33,4)   == binomial(33,4)
@test Mahler.bin(133,44) == binomial(big(133),big(44))
@test Mahler.bin(4.0,3)  == 4.0
@test Mahler.bin(3.0,4)  == 0.0
@test Mahler.bin(33.0,4)  ≈ Mahler.bin(33,4)
@test Mahler.bin(133.0,4) ≈ Mahler.bin(133,4)

#--------------------------------------------------------------------------------------------------
