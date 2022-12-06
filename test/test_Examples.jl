include("../src/Examples.jl")
using Test

@testset "Examples - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    @test isa(base_url, String)
end
