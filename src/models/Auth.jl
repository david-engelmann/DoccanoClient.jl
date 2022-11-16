
struct Auth
    csrf_token::String
    username::String
    password::String
end

function Auth(data::AbstractDict{Symbol, <: AbstractString})
    auth_fields = fieldnames(Auth)
    auth_fields = [auth_fields...,]
    missing_fields = setdiff(auth_fields, keys(data))
    if !isempty(missing_fields)
        @info "Missing the Following Required Components: " * join(missing_fields, ", ")
    end
    Auth((data[field] for field in auth_fields)...)
end

Auth(file_name::AbstractString) = Auth(JSON.parsefile(file_name; dicttype=Dict{Symbol, String}))
Auth(io::IO) = Auth(JSON.parse(io; dicttype=Dict{Symbol, String}))
