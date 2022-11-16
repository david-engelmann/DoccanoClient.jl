include("../models/Auth.jl")

function authorize(base_url :: String, username :: String, password :: String, version = "v1")
    @info "Retrieve CSRF Token"
    csrf_token = get_csrf_token(base_url)
    @info "Login with CSRF Token"
    csrf_token = login(base_url, username, password, csrf_token, version)
    @inf "Load Auth"
    return Auth(csrf_token, username, password)
end

function get_csrf_token(base_url :: String)
    base_url = if endswith(base_url, "/") base_url else base_url * "/" end
    url = base_url * "admin/login/"
    println(url)
    HTTP.open("GET", url, cookies = true) do io
        while !eof(io)
            readavailable(io)

            cookie_string = Dict(io.message.headers)["Set-Cookie"]
            cookie_arry = split(cookie_string, ";")
            csrf_token = [cookie for cookie in cookie_arry if occursin("csrf", cookie)][1]
            global csrf_token = String(split(csrf_token, "=")[2])

        end
    end
    return csrf_token
end

function make_login_post(url :: String, headers:: Vector{Pair{String, String}}, user_body :: HTTP.Form)
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function login(base_url :: String, username :: String, password :: String, csrf :: String,  version = "v1")
    base_url = if endswith(base_url, "/") base_url else base_url * "/" end
    base_url = base_url * version * "/"
    url = base_url *  "auth/login/"
    println(url)
    user_body = HTTP.Form(Dict(["username"=>username, "password"=>password]))
    headers = [
        "X-CSRFToken"=>csrf, 
        "referer"=>base_url
        ]

    r = make_login_post(url, headers, user_body)
    header_arry = [h for h in r.headers if occursin("csrf", h[2])]
    cookie_string = Dict(header_arry[1])["Set-Cookie"]
    cookie_arry = split(cookie_string, ";")
    csrf_token = [cookie for cookie in cookie_arry if occursin("csrf", cookie)][1]
    global csrf_token = String(split(csrf_token, "=")[2])
    return csrf_token
end

