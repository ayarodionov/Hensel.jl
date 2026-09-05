#--------------------------------------------------------------------------------------------------
using Test

#--------------------------------------------------------------------------------------------------

@testset "Hensel" begin
    @testset "Linear mapping tests" begin
        include("linear_mapping_tests.jl")
    end
    @testset "Functions on [a,b] tests" begin
        include("functions_on_ab_tests.jl")
    end
    @testset "Functions on [0,1] tests" begin
        include("functions_on_01_tests.jl")
    end
    @testset "LinMap tests" begin
        include("LinMap_tests.jl")
    end
    @testset "FunEnv tests" begin
        include("FunEnv_tests.jl")
    end
    @testset "Additional functions tests" begin
        include("additional_functions_tests.jl")
    end
    @testset "Mahler" begin
        @testset "sundry tests" begin
            include("sunry_tests.jl")
        end
        @testset "mfill tests" begin
            include("mfill_tests.jl")
        end
        @testset "mexpansion tests" begin
            include("mexpansion_tests.jl")
        end
    end
    @testset "van der Put tests" begin
        include("vanderput_tests.jl")
    end
end

#--------------------------------------------------------------------------------------------------
