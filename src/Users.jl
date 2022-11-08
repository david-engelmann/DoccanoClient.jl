#include("DoccanoClient.jl")
#include("../test/test_Auth.jl")
#using DoccanoClient: csrf_token as csrf_token

function create_users_url(base_url :: String, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "users" * raw"/" * url_suffix
    else
        return base_url * "users"
    end
end

function create_current_user_url(base_url :: String, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "me" * raw"/" * url_suffix
    else
        return base_url * "me"
    end
end

function get_users(base_url :: String, _csrf_token :: String, version :: String="v1")
    url = create_users_url(base_url, version) 
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global users = JSON3.read(String(readavailable(io)))
        end
    end
    return users   
end

function get_current_user(base_url :: String, _csrf_token :: String, version :: String="v1")
    url = create_current_user_url(base_url, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global current_user = JSON3.read(String(readavailable(io)))
        end
    end
    return current_user      
end


#base_url = ENV["DOCCANO_BASE_URL"]
#users = get_users(base_url, "users", csrf_token)
#my_user = get_current_user(base_url, "me", csrf_token)

#println(my_user)
