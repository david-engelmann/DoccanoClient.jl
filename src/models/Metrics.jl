struct LabelCount
    label::String
    count::Integer
end

struct LabelDistribution
    username::String
    counts::Array{LabelCount}
end

struct Progress
    total::Integer
    remaining::Integer
    completed::Integer
end

struct MemberProgress
    username::String
    progress::Progress
end
