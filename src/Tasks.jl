#include("DoccanoClient.jl")
include("Projects.jl")

function create_url_query(url :: String, url_parameters :: Dict)
    url = URI(url)
    url = URI(url; query=url_parameters)
    return string(url)
end

function create_task_id_status_url(base_url :: String, task_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * "tasks/status" * raw"/" * string(task_id) * raw"/" * url_suffix
    else
        return base_url * "tasks/status" * raw"/" * string(task_id)
    end 
end

function create_task_id_download_url(base_url :: String, project_id :: Integer, task_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    url = create_project_id_url(base_url, "projects", project_id, version, "download")
    task_id_payload = Dict([
        "taskId" => task_id
    ]) 
    return create_url_query(url, task_id_payload)
end

function make_task_id_status_request(url :: String, headers :: Vector{Pair{String, String}})
    return HTTP.get(url, headers; cookies = true)
end

function make_task_id_download_request(url :: String, headers :: Vector{Pair{String, String}})
    return HTTP.get(url, headers; cookies = true)
end