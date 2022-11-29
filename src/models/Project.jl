Base.@kwdef struct Project
    id::Union{Integer, nothing}
    name::String
    description::String
    guideline::String
    project_type::String
    random_order::Bool = false
    collaborative_annotation::Bool = false
    single_class_classification::Bool = false
    allow_overlapping::Bool = false
    grapheme_mode::Bool = false
    use_relation::Bool = false
    tags::Array{String} = []
end
