struct Project
    id::Integer
    name::String
    description::String
    guideline::String
    project_type::String
    random_order::Boolean
    collaborative_annotation::Boolean
    single_class_classification::Boolean
    allow_overlapping::Boolean
    grapheme_mode::Boolean
    use_relation::Boolean
    tags::Array
end
