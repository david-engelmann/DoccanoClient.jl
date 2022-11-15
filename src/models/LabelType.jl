struct LabelType
    id::Integer
    text::String
    prefix_key::String
    suffix_key::String
    background_color::String
    text_color::String
end

struct CategoryType <: LabelType
end

struct SpanType <: LabelType
end

struct RelationType <: LabelType
end


