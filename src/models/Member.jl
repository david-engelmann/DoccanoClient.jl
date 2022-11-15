Base.@kwdef struct Member
    id::Union{Integer, nothing}
    user::Integer
    role::Integer
    username::String = ""
    rolename::String = ""
end
