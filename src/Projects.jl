#include("DoccanoClient.jl")
include("./models/Project.jl")
using HTTP

#=
function parseattr(attr) :: String
  attr = string(attr)

  for (k,v) in Dict("v__on!" => "v-on:")
    attr = replace(attr, k=>v)
  end
  return attr
end

function parse_non_string_for_form(attr)
    a = IOBuffer()
    println("Target Attribute")
    println(typeof(attr[2]))
    if isa(attr[2], Bool)
        return attr[1] => parseattr(attr[2])
    end
end
=#

function create_project_id_url(base_url :: String, endpoint :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    if url_suffix !== nothing
        return base_url * endpoint * raw"/" * string(project_id) * raw"/" * url_suffix
    else
        return base_url * endpoint * raw"/" * string(project_id)
    end 
end

function create_project_url(base_url :: String, endpoint :: String, version :: String="v1")
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    base_url = base_url * version * raw"/"
    return base_url * endpoint
end

function get_projects(base_url :: String, _csrf_token :: String, version :: String="v1")
    url = create_project_url(base_url, "projects", version)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global projects = JSON3.read(String(readavailable(io)))
        end
    end
    return projects
end

function get_project_detail(base_url :: String, project_id :: Integer, _csrf_token :: String, version ::String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_detail = JSON3.read(String(readavailable(io)))
        end
    end
    return project_detail
end

function get_next_project_batch(project_url :: String, _csrf_token :: String)
    headers = ["X-CSRFToken"=>_csrf_token]
    r = HTTP.request("GET", project_url, headers; cookies = true)
    return JSON3.read(String(r.body)) 
end

function get_all_projects(base_url :: String, _csrf_token :: String, version ::String="v1")
    project_arry = []
    project_results = get_projects(base_url, _csrf_token, version)
    for prj in project_results["results"]
        push!(project_arry, prj)
    end
    while project_results["next"] !== nothing
        project_results = get_next_project_batch(project_results["next"], _csrf_token)
        for prj in project_results["results"]
            push!(project_arry, prj)
        end
    end
    for prj in project_results["results"]
        if !(prj in project_arry)
            push!(project_arry, prj)
        end
    end
    return project_arry
end

function make_create_project_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function make_update_project_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.patch(url, headers, body=user_body; cookies = true)
end

function make_delete_project_request(url :: String, headers:: Vector{Pair{String, String}})
    return HTTP.delete(url, headers; cookies = true)
end

function make_export_project_request(url :: String, headers :: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function create_project(base_url :: String, name :: String, _csrf_token :: String, description :: String="", project_type :: String="DocumentClassification", guideline :: String="", resourcetype :: String="TextClassificationProject", randomize_document_order :: Bool=false, collaborative_annotation :: Bool=false, version :: String="v1")
    url = create_project_url(base_url, "projects", version)
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json", # Comment out with HTTP.Form, 
                "accept" => "application/json"]
    if typeof(randomize_document_order) == Bool
        if randomize_document_order == false
            randomize_document_order = 0
        else
            randomize_document_order = 1
        end
    end

    if typeof(collaborative_annotation) == Bool
        if collaborative_annotation == false
            collaborative_annotation = 0
        else
            collaborative_annotation = 1
        end
    end
    project_payload = Dict([
        "name" => name,
        "description" => description,
        "project_type" => project_type,
        "guideline" => guideline,
        "resourcetype" => resourcetype,
        "randomize_document_order" => randomize_document_order,
        "collaborative_annotation" => collaborative_annotation
        ])

    r = make_create_project_request(url, headers, JSON3.write(project_payload))    
    return JSON3.read(r.body)
end

function update_project(base_url :: String, project_id :: Integer, _csrf_token :: String, name :: String, description :: String="", project_type :: String="DocumentClassification", guideline :: String="", resourcetype :: String="TextClassificationProject", randomize_document_order :: Bool=false, collaborative_annotation :: Bool=false, version :: String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json",
               "accept" => "application/json"]
    if typeof(randomize_document_order) == Bool
        if randomize_document_order == false
            randomize_document_order = 0
        else
            randomize_document_order = 1
        end
    end

    if typeof(collaborative_annotation) == Bool
        if collaborative_annotation == false
            collaborative_annotation = 0
        else
            collaborative_annotation = 1
        end
    end

    project_payload = Dict(["name" => name,
                            "description" => description,
                            "project_type" => project_type,
                            "guideline" => guideline,
                            "resourcetype" => resourcetype,
                            "randomize_document_order" => randomize_document_order,
                            "collaborative_annotation" => collaborative_annotation])

    r = make_update_project_request(url, headers, JSON3.write(project_payload))
    return JSON3.read(r.body)
end

function update_project_elements(base_url :: String, project_id :: Integer, _csrf_token :: String;  name :: Union{String, Nothing}=nothing, description :: Union{String, Nothing}=nothing, project_type :: Union{String, Nothing}=nothing, guideline :: Union{String, Nothing}=nothing, resourcetype :: Union{String, Nothing}=nothing, randomize_document_order :: Union{Bool, Nothing}=nothing, collaborative_annotation :: Union{Bool, Nothing}=nothing, version :: String="v1")
    project_detail = get_project_detail(base_url, project_id, _csrf_token, version)
    if name == nothing
        name = project_detail["name"]
    end
    if description == nothing
        description = project_detail["description"]
    end
    if project_type == nothing
        project_type = project_detail["project_type"]
    end
    if guideline == nothing
        guideline = project_detail["guideline"]
    end
    if resourcetype == nothing
        resourcetype = project_detail["resourcetype"]
    end
    if randomize_document_order == nothing
        randomize_document_order = project_detail["random_order"]
    end
    if collaborative_annotation == nothing
        collaborative_annotation = project_detail["collaborative_annotation"]
    end
    return update_project(base_url, project_id, name, _csrf_token, description, project_type, guideline, resourcetype, randomize_document_order, collaborative_annotation, version)
end

function delete_project(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    r = make_delete_project_request(url, headers)
end

function delete_projects(base_url :: String, project_ids :: Vector{Integer}, _csrf_token :: String, version :: String="v1")
    headers = ["X-CSRFToken"=>_csrf_token]
    for project_id in project_ids
        url = create_project_id_url(base_url, "projects", project_id, version)
        r = make_delete_project_request(url, headers)
    end
end

function export_project(base_url :: String, project_id :: Integer, save_path:: String, _csrf_token :: String, file_format :: String="json", only_approved :: Bool=false, version :: String="v1")
    download_url = create_project_id_url(base_url, "projects", project_id, version, "download")
    file_format = lowercase(file_format)

    if file_format == "csv"
        accept_format = "text/csv"
    else 
        accept_format = "application/$(file_format)"
    end

    headers = ["X-CSRFToken"=>_csrf_token, # "Content-Type" => "application/json",
               "accept" => accept_format]
    status_headers = ["X-CSRFToken"=>_csrf_token]
    task_download_headers = ["X-CSRFToken"=>_csrf_token]

    if file_format == "csv"
        json_final_format = "CSV"
    elseif file_format == "jsonl"
        json_final_format = "JSONL"
    else 
        json_final_format = "JSON"
    end

    format_payload = Dict([
        "exportApproved": only_approved,
        "format": json_final_format
    ])
    result = make_export_project_request(download_url, headers, JSON3.write(format_payload))
    task_id = result["task_id"]
    while true
        task_id_status_url = create_task_id_status_url(base_url, task_id, version)
        result = make_task_id_status_request(task_id_status_url, status_headers)
        if result["ready"] == true
            break
        end
    end
    #Get File
    task_id_download_url = create_task_id_download_url(base_url, project_id, task_id, version)
    result = make_task_id_download_request(task_id_download_url, task_download_headers)

    #Save File
    println(JSON3.read(result.body))
end

#=
#base_url = ENV["DOCCANO_BASE_URL"]
#println(delete_project(base_url, 108, csrf_token))
#println(update_project(base_url, 107, "david-changed-name-from-julia", csrf_token, "this is the new description set from julia2", "DocumentClassification", "Guidelines", "TextClassificationProject", true, true))
#println(create_project(base_url, "david-create-project-julia-name-tbd", csrf_token, "test changing names from julia"))
#println(get_all_projects(base_url, "projects", csrf_token)[1])
=#
