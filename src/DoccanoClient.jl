include("Tasks.jl")
include("authorization/Credentials.jl")
#module DoccanoClient

#=
Activate the Enviroment
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

#=
base_url = ENV["DOCCANO_BASE_URL"]
username = ENV["DOCCANO_USERNAME"]
password = ENV["DOCCANO_PASSWORD"]

csrf_token = get_csrf_token(base_url)
csrf_token = login(base_url, username, password, csrf_token)
=#

export csrf_token

#end
