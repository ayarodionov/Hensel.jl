#--------------------------------------------------------------------------------------------------
# Additional functions tests
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------

@test Hensel.logistic(Hensel.logistic(Hensel.logistic(0.3, 4.0), 4.0), 4.0) ==  Hensel.logistic(0.3,4.0,3)
@test Hensel.dyadic(Hensel.dyadic(Hensel.dyadic(0.3))) ==  Hensel.dyadic(0.3,3)
@test Hensel.nyadic(Hensel.nyadic(Hensel.nyadic(0.3, 5), 5), 5) ==  Hensel.nyadic(0.3,5,3)
@test Hensel.cfshift(Hensel.cfshift(Hensel.cfshift(0.3))) ==  Hensel.cfshift(0.3,3)


@test ((y) -> Hensel.FunEnv((x) -> Hensel.dyadic(0.35,y), (0, 1), 2, 8)(y, return_type="integer")).(0:10) == [
    154,
    205,
    102,
     51,
    153,
    204,
    102,
     51,
    153,
    204,
    102
]

@test ((y) -> Hensel.FunEnv((x) -> Hensel.nyadic(0.35,2,y), (0, 1), 2, 8)(y, return_type="integer")).(0:10) == [
    154,
    205,
    102,
     51,
    153,
    204,
    102,
     51,
    153,
    204,
    102
]

@test Hensel.FunEnv(Hensel.dyadic, (0, 1), 2, 8)(1,2,return_type="integer") == 64
@test Hensel.FunEnv(Hensel.dyadic, (0, 1), 2, 8)((1,2,"integer")) == 64
@test Hensel.FunEnv(Hensel.dyadic, (0, 1), 2, 8)((1,2)) == 64
@test Hensel.FunEnv(Hensel.dyadic, (0, 1), 2, 8).([(1,1),(1,2),(1,3)]) == [128, 64, 32]
@test Hensel.FunEnv(Hensel.dyadic, (0, 1), 2, 8).([(1,1,"hensel"),(1,2,"hensel"),(1,3,"hensel")]) == [
    [0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 1, 0, 0]    
]

#--------------------------------------------------------------------------------------------------
