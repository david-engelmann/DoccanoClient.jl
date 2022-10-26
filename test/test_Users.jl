include("../src/Users.jl")
using Test
using JSON3

@testset "Users - Get Functions" begin
    base_url = "http://127.0.0.1"
    version = "v1"
    users = get_users(base_url, csrf_token, version)
    admin_block = [usr for usr in users if usr["id"] == 1]
    expected_result_string = """{

             "id": 1,

       "username": "admin",

   "is_superuser": true,

       "is_staff": true

}"""
    current_user = get_current_user(base_url, "me", csrf_token)
    @test isempty(users) == false
    @test admin_block[1] == JSON3.read(expected_result_string)
    @test isempty(current_user) == false
    @test current_user == admin_block[1]
    @test current_user == JSON3.read(expected_result_string)
end

@testset "Users - Link Creation" begin
    base_url = "http://127.0.0.1"
    version = "v1"
    # base_url, version, suffix
    no_suffix_user_url = create_users_url(base_url, version)
    no_suffix_current_user_url = create_current_user_url(base_url, version)

    @test no_suffix_user_url == "$(base_url)/$(version)/users"
    @test no_suffix_current_user_url == "$(base_url)/$(version)/me"
end