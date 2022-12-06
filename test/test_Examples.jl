include("../src/Examples.jl")
using Test

@testset "Examples - Upload Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    sample_classification_file_name = "sample_classification_inputs.jsonl"
    sample_classification_file_path = "test/assets"
    @test isa(base_url, String)
end

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

    example_upload_url = create_example_upload_url(base_url, test_project_id, version)
    test_example_upload_url = if endswith(base_url, raw"/") "$(base_url)$(version)/projects/$(test_project_id)/upload" else "$(base_url)/$(version)/projects/$(test_project_id)/upload" end
    @test example_upload_url == test_example_upload_url

    fp_process_url = create_fp_process_url(base_url, version)
    test_fp_process_url = if endswith(base_url, raw"/") "$(base_url)$(version)/fp/process/" else "$(base_url)/$(version)/fp/process/" end
    @test fp_process_url == test_fp_process_url

    fp_revert_url = create_fp_revert_url(base_url, version)
    test_fp_revert_url = if endswith(base_url, raw"/") "$(base_url)$(version)/fp/revert/" else "$(base_url)/$(version)/fp/revert/" end
    @test fp_revert_url == test_fp_revert_url
end
