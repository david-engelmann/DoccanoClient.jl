include("../src/DoccanoClient.jl")
using Test

@testset "CSRF Token" begin
    @test @isdefined csrf_token
    @test isempty(csrf_token) == false
end

@testset "Login" begin
    username = "admin"
    password = "password"
    base_url = "http://127.0.0.1"
    version = "v1"
    @test login(base_url, username, password, csrf_token, version) == csrf_token
end
