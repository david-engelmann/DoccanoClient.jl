Base.@kwdef struct Example
    id::Union{Integer, nothing}
    text::Union{Integer, nothing} = nothing
    meta::Dict = Dict()
    annotation_approver::Union{String, nothing} = nothing
    comment_count::Integer = 0
    is_confirmed::Bool = false
    filename::String = ""
    upload_name::String = ""
    score::Float = 100.0
end
