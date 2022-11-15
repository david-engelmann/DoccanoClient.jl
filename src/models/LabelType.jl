struct LabelType
    id::Union{Integer, nothing}
    text::String
    prefix_key::Union{String, nothing}
    suffix_key::Union{String, nothing}
    background_color::String
    text_color::String
end

struct CategoryType <: LabelType
end

struct SpanType <: LabelType
end

struct RelationType <: LabelType
end


