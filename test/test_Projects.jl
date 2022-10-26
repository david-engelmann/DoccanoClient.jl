include("../src/Projects.jl")
using Test

@testset "Projects" begin
    base_url = "http://127.0.0.1"
    projects = get_projects(base_url, csrf_token, "v1")
    test_project_id = 106
    project_detail = get_project_detail(base_url, test_project_id, csrf_token, "v1")
    @test isempty(projects) == false
    @test isempty(project_detail) == false
end
