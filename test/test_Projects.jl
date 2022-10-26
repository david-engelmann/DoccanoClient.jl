include("../src/Projects.jl")
using Test

@testset "Projects" begin
    try
        base_url = ENV["DOCCANO_BASE_URL"]
        test_project_id = ENV["DOCCANO_TEST_PROJECT_ID"]
    catch err
        base_url = "http://127.0.0.1"
        test_project_id = 106
    end
    projects = get_projects(base_url, csrf_token, "v1")
    project_detail = get_project_detail(base_url, test_project_id, csrf_token, "v1")
    @test isempty(projects) == false
    @test isempty(project_detail) == false
end
