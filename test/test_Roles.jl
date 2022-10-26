include("../src/Roles.jl")
using Test

@testset "Roles - Get Functions" begin
    base_url = "http://127.0.0.1"
    roles = get_roles(base_url, csrf_token, "v1")
    test_project_id = 106
    target_role_id = 1
    rolemappings = get_rolemappings(base_url, test_project_id, csrf_token, "v1")
    @test isempty(roles) == false
    @test isempty(rolemappings) == false
end


@testset "Roles - Link Creation" begin
    base_url = "http://127.0.0.1"
    version = "v1"
    test_project_id = 106
    # base_url, version, suffix
    no_suffix_role_url = create_roles_url(base_url, version)
    no_suffix_project_role_url = create_project_roles_url(base_url, project_id, version)

    @test no_suffix_role_url == "$(base_url)/$(version)/roles"
    @test no_suffix_project_role_url = "$(base_url)/$(version)/projects/$(test_project_id)"
end
