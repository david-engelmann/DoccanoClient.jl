include("../src/Roles.jl")
using Test

@testset "Roles - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 0
    roles = get_roles(base_url, csrf_token, "v1")
    @info roles
    target_role_id = 1
    rolemappings = get_rolemappings(base_url, test_project_id, csrf_token, "v1")
    @test isempty(roles) == false
    @test isempty(rolemappings) == false
end


@testset "Roles - Link Creation" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 0
    version = "v1"
    no_suffix_role_url = create_roles_url(base_url, version)
    no_suffix_project_role_url = create_project_roles_url(base_url, project_id, version)

    test_no_suffix_role_url = if endswith(base_url, raw"/") "$(base_url)$(version)/roles" else "$(base_url)/$(version)/roles" end
    test_no_suffix_project_role_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)" else "$(base_url)/$(version)/projects/$(test_project_id)" end
    @test no_suffix_role_url == test_no_suffix_role_url
    @test no_suffix_project_role_url = test_no_suffix_project_role_url
end
