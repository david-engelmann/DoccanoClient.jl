Base.@kwdef struct Comment
    id::Union{Integer, Nothing} = nothing
    text::String
    example::Integer
    user::Union{Integer, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    created_at::Union{String, Nothing} = nothing
end
