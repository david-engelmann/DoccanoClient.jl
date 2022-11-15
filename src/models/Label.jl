struct Label
    id::Integer
    example::Integer
    prob::Float
    manual::Boolean
    user::Integer
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
    x::Float
    y::Float
    width::Float
    height::Float
    label::Integer
end

struct Segment <: Label
    points::Array{Float}
    label::Integer
end

struct Text <: Label
    text::String
end
