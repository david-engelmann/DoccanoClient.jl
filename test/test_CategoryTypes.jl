include("../src/CategoryTypes.jl")
using Test

@testset "CategoryTypes - Upload Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    sample_category_types_file_name = "label_multi_label_alpha.json"
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
    @test length(category_types["results"]) == 2
    @test isa(test_category_type_detail["text"], String)
end

@testset "CategoryTypes - CategoryType Id Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    category_type_ids = get_category_type_ids(base_url, test_project_id, csrf_token, version)
    @test length(category_type_ids) == 2
    @test category_type_ids == collect(1:2)
end

@testset "CategoryTypes - Update Functions" begin
    base_url = ENV["DOCCANO_BASE_URL"]
    test_project_id = 1
    version = "v1"
    category_types = get_category_types(base_url, test_project_id, csrf_token, version)
    test_category_type_id = first(category_types["results"])["id"]
    test_category_type_detail = get_category_type_detail(base_url, test_project_id, test_category_type_id, csrf_token)
    update_category_type_name = test_category_type_detail["text"] + "zzzz"
    update_response = update_category_type_elements(base_url, test_project_id, test_category_type_id, csrf_token, update_category_type_name)
    test_category_type_detail = get_category_type_detail(base_url, test_project_id, test_category_type_id, csrf_token)
    @test endswith(test_category_type_detail["text"], "zzzz")

end

@testset "CategoryTypes - Link Creation" begin
    @info "Testing Link Creation"
    @test false == true
end

