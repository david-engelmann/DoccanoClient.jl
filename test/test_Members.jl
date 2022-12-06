include("../src/Members.jl")
using Test

@testset "Members - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 0
    target_role_id = 1
    version = "v1"
    #=
    @info "Test adding Members to Project"
    project_attachment_results = attach_members_to_project(base_url, test_project_id, ["admin"], ["project_admin"], csrf_token, version)
    =#
    @info "Project Memeber Results"
    members = get_members(base_url, test_project_id, csrf_token, version)
    @info members
    @test isempty(members) == false
end


@testset "Members - Link Creation" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 0
    test_member_id = 1
    version = "v1"
    no_suffix_project_member_url = create_project_members_url(base_url, test_project_id, version)
    suffix_project_member_url = create_project_members_url(base_url, test_project_id, version, test_member_id)

    test_no_suffix_member_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)/members" else "$(base_url)/$(version)/members" end
    test_suffix_project_member_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)/members/{test_member_id}" else "$(base_url)/$(version)/projects/$(test_project_id)/members/{test_member_id}" end
    @test no_suffix_member_url == test_no_suffix_member_url
    @test no_suffix_project_member_url = test_no_suffix_project_member_url
end
