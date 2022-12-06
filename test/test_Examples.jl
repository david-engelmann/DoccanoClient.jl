include("../src/Examples.jl")
using Test

@testset "Members - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    assert isa(base_url, String)
end
