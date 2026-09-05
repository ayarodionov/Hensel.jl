#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------

@test Mahler.mexpansion((x)->2,    5) == [2,0,0,0,0]
@test Mahler.mexpansion((x)->x,    5) == [0,1,0,0,0]
@test Mahler.mexpansion((x)->x+1,  5) == [1,1,0,0,0]
@test Mahler.mexpansion((x)->2*x+1,5) == [1,2,0,0,0]

@test Mahler.mval(  9,Mahler.mexpansion((x) ->    +1, 5)) == 1
@test Mahler.mval(  0,Mahler.mexpansion((x) -> 2*x+1, 5)) == 1
@test Mahler.mval(0.5,Mahler.mexpansion((x) -> 2*x+1, 5)) == 2
@test Mahler.mval(  1,Mahler.mexpansion((x) -> 2*x+1, 5)) == 3
@test Mahler.mval(5.5,Mahler.mexpansion((x) -> 2*x+1, 5)) == 12

@test Mahler.mval(1,Mahler.mexpansion(log1p, 10)) ≈ log1p(1) 
@test Mahler.mval(2,Mahler.mexpansion(log1p, 10)) ≈ log1p(2) 
@test Mahler.mval(9,Mahler.mexpansion(log1p, 10)) ≈ log1p(9) 

#--------------------------------------------------------------------------------------------------
