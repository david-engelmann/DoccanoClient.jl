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
    @info "Testing getting"
    @test false == true
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

