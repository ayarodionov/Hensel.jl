#--------------------------------------------------------------------------------------------------
# FunEnv tests
#--------------------------------------------------------------------------------------------------
using Test
using Hensel

#--------------------------------------------------------------------------------------------------

@test Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2))(0.25) == 1.25
@test Hensel.to01(1.25, (1, 2)) == 0.25

@test Hensel.hVector(0.25, 2, 5) == [0,1,0,0,0]
@test Hensel.iValue(Hensel.hVector(0.25, 2, 5), 2) == 2
@test Hensel.rValue(2, 2, 5) == 0.265625
@test Hensel.rValue(2, 2, 5, (1, 2)) == 1.265625
@test Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2))(2) == 2
@test Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2))(2, return_type="hensel") == [0,1,0,0,0]
@test Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2))(2, return_type="real") == 1.265625
@test Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2)).(0:9) == 0:9
@test ((y) -> Hensel.FunEnv((x) -> x+1, (0, 1), 2, 5, (1, 2))(y, return_type="real")).(0:9) == [
    1.015625,
    1.515625,
    1.265625,
    1.765625,
    1.140625,
    1.640625,
    1.390625,
    1.890625,
    1.078125,
    1.578125, 
]

@test Hensel.hVector(0.25, 3, 5) == [0,2,0,2,0]
@test Hensel.iValue(Hensel.hVector(0.25, 3, 5), 3) == 60
@test Hensel.FunEnv((x) -> x+1, (0, 1), 3, 5, (1, 2))(60) == 60
@test Hensel.FunEnv((x) -> x+1, (0, 1), 3, 5, (1, 2))(60, return_type="hensel") == [0,2,0,2,0]
@test Hensel.FunEnv((x) -> x+1, (0, 1), 3, 5, (1, 2))(60, return_type="real") == 1.2489711934156378
@test Hensel.FunEnv((x) -> x+1, (0, 1), 3, 5, (1, 2)).(0:9) == 0:9
@test ((y) -> Hensel.FunEnv((x) -> x+1, (0, 1), 3, 5, (1, 2))(y, return_type="real")).(0:9) == [
    1.0020576131687242,
    1.3353909465020577,
    1.668724279835391,
    1.1131687242798354,
    1.4465020576131686,
    1.7798353909465021,
    1.2242798353909465,
    1.5576131687242798,
    1.8909465020576133,
    1.0390946502057614
]

@test Hensel.hVector(0.25, 7, 5) == [1,5,1,5,1]
@test Hensel.iValue(Hensel.hVector(0.25, 7, 5), 7) == 4201
@test Hensel.FunEnv((x) -> x+1, (0, 1), 7, 5, (1, 2))(4201) == 4201
@test Hensel.FunEnv((x) -> x+1, (0, 1), 7, 5, (1, 2))(4201, return_type="hensel") == [1,5,1,5,1]
@test Hensel.FunEnv((x) -> x+1, (0, 1), 7, 5, (1, 2))(4201, return_type="real") == 1.2499851252454335
@test Hensel.FunEnv((x) -> x+1, (0, 1), 7, 5, (1, 2)).(0:9) == 0:9
@test ((y) -> Hensel.FunEnv((x) -> x+1, (0, 1), 7, 5, (1, 2))(y, return_type="real")).(0:9) == [
    1.000029749509133,
    1.142886892366276,
    1.2857440352234188,
    1.4286011780805616,
    1.5714583209377047,
    1.7143154637948474,
    1.8571726066519902,
    1.0204379127744392,
    1.163295055631582,
    1.306152198488725
]

# -----------------------------------------------------------------
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 5, (2, 5))(0.25) == 2.75
@test Hensel.to01(2.75, (2, 5)) == 0.25

@test Hensel.hVector(0.25, 2, 5) == [0,1,0,0,0]
@test Hensel.iValue(Hensel.hVector(0.25, 2, 5), 2) == 2
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 5, (2, 5))(2) == 2
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 5, (2, 5))(2, return_type="hensel") == [0,1,0,0,0]
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 5, (2, 5))(2, return_type="real") == 2.796875
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 5, (2, 5)).(0:9) == 0:9

@test Hensel.hVector(0.25, 3, 5) == [0,2,0,2,0]
@test Hensel.hVector(1//4, 3, 5) == [0,2,0,2,0]
@test Hensel.iValue(Hensel.hVector(0.25, 3, 5), 3) == 60
@test Hensel.iValue(Hensel.hVector(1//4, 3, 5), 3) == 60
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 3, 5, (2, 5))(60) == 60
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 3, 5, (2, 5))(60, return_type="hensel") == [0,2,0,2,0]
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 3, 5, (2, 5))(60, return_type="real") == 2.746913580246914
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 3, 5, (2, 5)).(0:9) == 0:9

@test Hensel.hVector(0.25, 7, 5) == [1,5,1,5,1]
@test Hensel.iValue(Hensel.hVector(0.25, 7, 5), 7) == 4201
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 7, 5, (2, 5))(4201) == 4201
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 7, 5, (2, 5))(4201, return_type="hensel") == [1,5,1,5,1]
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 7, 5, (2, 5))(4201, return_type="real") == 2.7499553757363002
@test Hensel.FunEnv((x) -> 3*x+2, (0, 1), 7, 5, (2, 5)).(0:9) == 0:9

@test Hensel.FunEnv((x) -> 0.6*x*(1.0-x), (0.0, 1.0), 2, 8, (0.0, 1.0)).(0:10) == [
    0,
    100,
     56,
     56,
    136,
    196,
     36,
      8,
    144,
    164,
    132
]
@test Hensel.FunEnv((x) -> 0.6*x*(1-x), (0.0, 1.0), 2, 8, (0.0, 1.0))(0.5) == 0.15
@test Hensel.rValue(Hensel.hVector(100, 2, 8), 2) == 0.150390625

#--------------------------------------------------------------------------------------------------

@test ((y) -> Hensel.δ(Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5)), y))(0.0) == -2^(-9)*3
@test ((y) -> Hensel.δ(Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5)), y))(0.3) == 0.003515624999999911
@test ((y) -> Hensel.δ(y, Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5))))(0.3) == 0
@test findmax(((y) -> abs(Hensel.δ(Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5)), y))).(collect(0:0.1:1))) == (2^(-9)*3, 1)
@test findmax(((y) -> abs(Hensel.δ(y, Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5))))).(collect(0:0.1:1))) == (0, 1)

#--------------------------------------------------------------------------------------------------

@test Hensel.mexpansion(Hensel.FunEnv((x) -> 3*x+2, (0, 1), 2, 8, (2, 5)), 8) == [0,1,0,0,0,0,0,0]
