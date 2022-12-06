Base.@kwdef struct Label
    id::Union{Integer, Nothing}
    example::Integer
    prob::Float64 = 0.0
    manual::Bool = false
    user::Union{Integer, Nothing} = nothing
end

struct Category <: Label
    label::Integer
end

struct Span <:Label
    label::Integer
    start_offset::Integer
    end_offset::Integer
end

struct Relation <: Label
    from_id::Integer
    to_id::Integer
    type::Integer
end

struct BoundingBox <: Label
    x::Float64
    y::Float64
    width::Float64
    height::Float64
    label::Integer
end

struct Segment <: Label
    points::Array{Float64}
    label::Integer
end

struct Text <: Label
    text::String
end
