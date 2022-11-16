include("../src/DoccanoClient.jl")
include("../src/authorization/Auth.jl")
include("../src/models/Auth.jl")
using Test

@testset "CSRF Token" begin
    @test @isdefined csrf_token
    @test isempty(csrf_token) == false
end

@testset "Login" begin
    try
        username = ENV["DOCCANO_USERNAME"]
        password = ENV["DOCCANO_PASSWORD"]
        base_url = ENV["DOCCANO_BASE_URL"]
    catch err
        username = "admin"
        password = "password"
        base_url = "http://127.0.0.1"
    end
    version = "v1"
    @test login(base_url, username, password, csrf_token, version) == csrf_token
end

@testset "Authorize" begin
    try
        username = ENV["DOCCANO_USERNAME"]
        password = ENV["DOCCANO_PASSWORD"]
        base_url = ENV["DOCCANO_BASE_URL"]
    catch err
        username = "admin"
        password = "password"
        base_url = "http://127.0.0.1"
    end
    version = "v1"
    auth = authorize(base_url, username, password, version)
    @test typeof(auth) <: Auth
    @test !isnothing(auth.csrf_token)
    @test !isempty(auth)
end
