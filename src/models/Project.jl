Base.@kwdef struct Project
    id::Union{Integer, nothing}
    name::String
    description::String
    guideline::String
    project_type::String
    random_order::Boolean = false
    collaborative_annotation::Boolean = false
    single_class_classification::Boolean = false
    allow_overlapping::Boolean = false
    grapheme_mode::Boolean = false
    use_relation::Boolean = false
    tags::Array{String} = []
end
