Base.@kwdef struct Example
    id::Union{Integer, Nothing}
    text::Union{Integer, Nothing} = nothing
    meta::Dict = Dict()
    annotation_approver::Union{String, Nothing} = nothing
    comment_count::Integer = 0
    is_confirmed::Bool = false
    filename::String = ""
    upload_name::String = ""
    score::Float64 = 100.0
end
