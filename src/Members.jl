include("./models/Member.jl")

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

