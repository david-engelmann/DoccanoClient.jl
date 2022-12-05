#include("DoccanoClient.jl")
include("Users.jl")
include("./models/Role.jl")


function create_roles_url(base_url :: String, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "roles" * raw"/" * url_suffix
    else
        return base_url * "roles"
    end
end

function get_roles(base_url :: String, _csrf_token :: String, version :: String="v1")
    url = create_roles_url(base_url, version)
    @info url
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global roles = JSON3.read(String(readavailable(io)))
        end
    end
    return roles
end

#base_url = ENV["DOCCANO_BASE_URL"]
#roles = get_roles(base_url, "roles", csrf_token)
