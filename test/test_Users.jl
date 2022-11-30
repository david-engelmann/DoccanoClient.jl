include("../src/Users.jl")
using Test
using JSON3

@testset "Users - Get Functions" begin
    #=
    try
        base_url = ENV["DOCCANO_BASE_URL"]
    catch err
        base_url = "http://127.0.0.1"
    end
    =#
    @info "Start Testing the get_users function"
    base_url = ENV["DOCCANO_BASE_URL"]
    version = "v1"
    users = get_users(base_url, csrf_token, version)
    admin_block = [usr for usr in users if usr["id"] == 1]
    expected_result_string = """{

             "id": 1,

       "username": "admin",

   "is_superuser": true,

       "is_staff": true

}"""
    @info "Start Testing the get_current_user function"
    current_user = get_current_user(base_url, csrf_token)
    @test isempty(users) == false
    @test admin_block[1] == JSON3.read(expected_result_string)
    @test isempty(current_user) == false
    @test current_user == admin_block[1]
    @test current_user == JSON3.read(expected_result_string)
end

@testset "Users - Link Creation" begin
    #=
    try
        base_url = ENV["DOCCANO_BASE_URL"]
    catch err
        base_url = "http://127.0.0.1"
    end
    =#
    base_url = ENV["DOCCANO_BASE_URL"]
    version = "v1"
    no_suffix_user_url = create_users_url(base_url, version)
    no_suffix_current_user_url = create_current_user_url(base_url, version)

    test_no_suffix_user_url = if endswith(base_url, raw"/") "$(base_url)$(version)/users" else "$(base_url)/$(version)/users" end
    test_no_suffix_current_user_url = if endswith(base_url, raw"/") "$(base_url)$(version)/me" else "$(base_url)/$(version)/me" end

    @test no_suffix_user_url == test_no_suffix_user_url
    @test no_suffix_current_user_url == test_no_suffix_current_user_url
end
