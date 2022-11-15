Base.@kwdef struct Comment
    id::Union{Integer, nothing} = nothing
    text::String
    example::Integer
    user::Union{Integer, nothing} = nothing
    username::Union{String, nothing} = nothing
    created_at::Union{String, nothing} = nothing
end
