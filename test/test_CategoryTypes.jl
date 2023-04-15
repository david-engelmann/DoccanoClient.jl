include("../src/CategoryTypes.jl")
using Test

@testset "CategoryTypes - Upload Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    sample_category_types_file_name = "sample_category_types.json"
    sample_category_types_file_path = "test/assets"
    upload_category_types(base_url, test_project_id, csrf_token, sample_category_types_file_name, sample_category_types_file_path)
    @test isa(base_url, String)
end

@testset "CategoryTypes - Get Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    category_types = get_category_types(base_url, test_project_id, csrf_token, version)
    test_category_type_id = first(category_types["results"])["id"]
    test_category_type_detail = get_category_type_detail(base_url, test_project_id, test_category_type_id, csrf_token)
    @test length(category_types["results"]) == 5
    @test isa(test_category_type_detail["text"], String)
end

@testset "CategoryTypes - CategoryType Id Functions" begin
    @info "Testing category_type_ids"
    @test false == true
end

@testset "CategoryTypes - Update Functions" begin
    @info "Testing updating"
    @test false == true
end

@testset "CategoryTypes - Link Creation" begin
    @info "Testing Link Creation"
    @test false == true
end

