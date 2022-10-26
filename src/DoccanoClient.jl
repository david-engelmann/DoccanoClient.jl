include("Tasks.jl")
#module DoccanoClient

#=
Activatet the Enviroment
=#
using Pkg
Pkg.activate(".")

#=
Libs
=#
using HTTP
using JSON3
using URIs
using Statistics
using InteractiveUtils
using HTTP.IOExtras

# Gets all info when the argument is an object
function allinfo(obj_)
   obj_type = typeof(obj_)
   display(fieldnames(obj_type))
   methodswith(obj_type)
end

# Gets all info when argument is a Type
function allinfo(type_::Type)
   display(fieldnames(type_))
   methodswith(type_)
end

# Gets all info when the argument is a parametric type of Type
function allinfo(type_::Type{T}) where T <: Type
   methodswith(type_)
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

#csrftoken = login("http://doccano.satisfi5.com", "auth/login/", "admin", "password")
csrf_token = get_csrf_token("http://doccano.satisfi5.com")
println(csrf_token)
csrf_token = login("http://doccano.satisfi5.com", "admin", "password", csrf_token)

export csrf_token

#end
