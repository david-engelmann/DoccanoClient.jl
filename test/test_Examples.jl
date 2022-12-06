include("../src/Examples.jl")
using Test

@testset "Examples - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    @test isa(base_url, String)
end

@testset "Examples - Link Creation" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    test_example_id = 1
    project_url = create_project_id_url(base_url, "projects", test_project_id, version)
    test_project_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)" else "$(base_url)/$(version)/projects" end
    @test project_url == test_project_url

    example_url = create_example_id_url(project_url, test_example_id)
    test_example_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)/$(test_example_id)" else "$(base_url)/$(version)/projects/$(test_project_id)/$(test_example_id)" end
    @test example_url == test_example_url
end
