Base.@kwdef struct Member
    id::Union{Integer, Nothing}
    user::Integer
    role::Integer
    username::String = ""
    rolename::String = ""
end
