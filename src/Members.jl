include("./models/Member.jl")
include("Roles.jl")

function create_project_members_url(base_url :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "projects" * raw"/" * string(project_id) * raw"/" * "members" * raw"/" * url_suffix
    else
        return base_url * "projects" * raw"/" * string(project_id) * raw"/" * "members"
    end
end

function get_members(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_members_url(base_url, project_id, version)
    @info url
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global members = JSON3.read(String(readavailable(io)))
        end
    end
    return members
end

function get_member_detail(base_url :: String, project_id :: Integer, member_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_members_url(base_url, project_id, version, string(member_id))
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global member_detail = JSON3.read(String(readavailable(io)))
        end
    end
    return member_detail
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

function make_attach_user_request(url :: String, headers :: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function attach_members_to_project(base_url :: String, project_id :: Integer, usernames :: Union{Vector{String}, String}, roles :: Union{Vector{String}, String}, _csrf_token :: String, version :: String="v1")
    url = create_project_members_url(base_url, project_id, version)
    all_members = get_users(base_url, _csrf_token, version)
    all_roles = get_roles(base_url, _csrf_token, version)

    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json", # Comment out with HTTP.Form, 
                "accept" => "application/json"]
    user_response = []
    for (username, rolename) in create_user_role_pairs(usernames, roles)
        member = [potential_member for potential_member in all_members if potential_member["username"] == username]
        member = member[1]

        role = [potential_role for potential_role in all_roles if potential_role["name"] == rolename]
        role = role[1]

        member_role_payload = Dict([
            "role"=>role["id"],
            "user"=>member["id"],
        ])
        r = make_attach_user_request(url, headers, JSON3.write(member_role_payload))
        push!(user_response, JSON3.read(r.body))
    end
    return user_response
end
