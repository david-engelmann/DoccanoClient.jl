include("../models/Auth.jl")

function authorize(base_url :: String, username :: String, password :: String, version = "v1")
    @info "Retrieve CSRF Token"
    csrf_token = get_csrf_token(base_url)
    @info "Login with CSRF Token"
    @info String(csrf_token)
    csrf_token = login(base_url, username, password, csrf_token, version)
    @info "Load Auth"
    @info String(csrf_token)
    return Auth(csrf_token, username, password)
end

function authorize_from_env(version = "v1")
    base_url = ENV["DOCCANO_BASE_URL"]
    username = ENV["DOCCANO_USERNAME"]
    password = ENV["DOCCANO_PASSWORD"]
    authorize(base_url, username, password, version)
end

function get_csrf_token(base_url :: String)
    base_url = if endswith(base_url, "/") base_url else base_url * "/" end
    url = base_url * "admin/login/"
    println(url)
    HTTP.open("GET", url, cookies = true) do io
        while !eof(io)
            readavailable(io)
            cookie_string = parse_cookies_for_csrf_header(io)
            cookie_arry = split(cookie_string, ";")
            csrf_token = [cookie for cookie in cookie_arry if occursin("csrf", cookie)][1]
            global csrf_token = String(split(csrf_token, "=")[2])
        end
    end
    return csrf_token
end

function parse_cookies_for_csrf_header(io)
    try
        return Dict(io.message.headers)["Set-Cookie"]
    catch e
        return Dict(io.message.headers)["Cookie"]
    end
end

function make_login_post(url :: String, headers:: Vector{Pair{String, String}}, user_body :: HTTP.Form)
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function login(base_url :: String, username :: String, password :: String, csrf :: String,  version = "v1")
    base_url = if endswith(base_url, "/") base_url else base_url * "/" end
    base_url = base_url * version * "/"
    url = base_url *  "auth/login/"
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

auth = authorize_from_env()
csrf_token = auth.csrf_token
