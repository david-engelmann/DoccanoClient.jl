#include("DoccanoClient.jl")
include("Users.jl")

function create_project_roles_url(base_url :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "projects" * raw"/" * string(project_id) * raw"/" * "roles" * raw"/" * url_suffix
    else
        return base_url * "projects" * raw"/" * string(project_id) * raw"/" * "roles"
    end 
end

function create_roles_url(base_url :: String, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "roles" * raw"/" * url_suffix
    else
        return base_url * "roles"
    end
end

function make_attach_user_request(url :: String, headers :: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function get_roles(base_url :: String, _csrf_token :: String, version :: String="v1")
    url = create_roles_url(base_url, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global roles = JSON3.read(String(readavailable(io)))
        end
    end
    return roles      
end

function get_rolemappings(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_roles_url(base_url, project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global rolemappings = JSON3.read(String(readavailable(io)))
        end
    end
    return rolemappings      
end

function get_rolemapping_detail(base_url :: String, project_id :: Integer, rolemapping_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_roles_url(base_url, project_id, version, string(rolemapping_id))
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global rolemapping_detail = JSON3.read(String(readavailable(io)))
        end
    end
    return rolemapping_detail      
end

function create_user_role_pairs(usernames :: Union{Vector{String}, String}, roles :: Union{Vector{String}, String})
    user_role_pairs = []
    if isa(roles, Vector)
        if length(usernames) == length(roles) && isa(usernames, Vector)
            for (name, role) in zip(usernames, roles)
                push!(user_role_pairs, name => role)
            end
        else
            if isa(usernames, Vector)
                for name in usernames
                    role = roles[1]
                    push!(user_role_pairs, name => role)
                end
            else
                push!(user_role_pairs, usernames => roles[1])
            end
        end
    else
        if isa(usernames, Vector)
            for name in usernames
                push!(user_role_pairs, name => roles)
            end
        else
            push!(user_role_pairs, usernames => roles)
        end
    end
    return user_role_pairs
end

function attach_users_to_project(base_url :: String, project_id :: Integer, usernames :: Union{Vector{String}, String}, roles :: Union{Vector{String}, String}, _csrf_token :: String, version :: String="v1")
    println("write this function")
    url = create_project_roles_url(base_url, project_id, version)
    all_users = get_users(base_url, _csrf_token, version)
    all_roles = get_roles(base_url, _csrf_token, version)

    user_response = []
    for (username, rolename) in create_user_role_pairs(usernames, roles)
        user = [potential_user for potential_user in all_users if potential_user["username"] == username]
        user = user[1]

        role = [potential_role for potential_role in all_roles if potential_role["rolename"] == rolename]
        role = role[1]
        
        user_role_payload = Dict([
            "id": 0,
            "role": role["id"],
            "rolename": rolename,
            "user": user["id"],
            "username": username
        ])
        r = make_attach_user_request(url, JSON3.write(user_role_payload))   
        push!(user_response, JSON3.read(r.body))
    end
    return user_response
end

roles = get_roles("http://doccano.satisfi5.com", "roles", csrf_token)