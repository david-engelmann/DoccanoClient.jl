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

struct PasswordRestriction
    min_lenght::Integer
    max_length::Integer
    strip_whitespace::Boolean
end

struct PasswordChange
    new_password::String
    confirm_password::String
end
