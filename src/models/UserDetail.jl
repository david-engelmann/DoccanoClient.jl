struct UserDetail
    pk::Integer
    username::String
    email::String
    first_name::String
    last_name::String
end

struct PasswordUpdated
    detail::String
end

Base.@kwdef struct PasswordRestriction
    min_lenght::Integer = 2
    max_length::Integer = 128
    strip_whitespace::Boolean = true
end

struct PasswordChange
    new_password::String
    confirm_password::String
end
