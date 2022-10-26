include("DoccanoClient.jl")
include("Projects.jl")
include("utils/Filenames.jl")

function create_category_type_url(base_url :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = create_project_id_url(base_url, "projects", project_id, version)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    if url_suffix !== nothing
        return base_url * "category-types" * raw"/" * url_suffix
    else
        return base_url * "category-types"
    end
end

function create_category_type_id_url(base_url :: String, category_type_id :: Integer, url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    if url_suffix !== nothing
        return base_url * string(category_type_id) * raw"/" * url_suffix
    else
        return base_url * string(category_type_id)
    end 
end


function create_category_type_upload_url(base_url :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = create_project_id_url(base_url, "projects", project_id, version)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    if url_suffix !== nothing
        return base_url * "category-types-upload" * raw"/" * url_suffix
    else
        return base_url * "category-types-upload"
    end
end

function make_create_category_type_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function make_update_category_type_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.patch(url, headers, body=user_body; cookies = true)
end

function make_category_type_upload_request(url :: String, headers :: Vector{Pair{String, String}}, file_io :: Union{Dict{String, Union{IOStream, IOBuffer}}, HTTP.Form, Dict{String, String}})
    return HTTP.post(url, headers, file_io; cookies = true)
end

function get_category_types(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_category_type_url(base_url, project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token]
    println(url)
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global category_types = JSON3.read(String(read(io)))
        end
    end
    return category_types 
end

function get_category_type_detail(base_url :: String, project_id :: Integer, category_type_id :: Integer, _csrf_token :: String, version ::String="v1")
    url = create_category_type_url(base_url, project_id, version, string(category_type_id))
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global category_type_detail = JSON3.read(String(read(io)))
        end
    end
    return category_type_detail
end

function create_category_type(base_url :: String, project_id :: Integer, _csrf_token :: String, text :: String, text_color :: String="#ffffff", background_color :: String="#cdcdcd", prefix_key :: Union{String, Nothing}=nothing, suffix_key :: Union{String, Nothing}=nothing, version :: String="v1")
    url = create_category_type_url(base_url, project_id, version)
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json", # Comment out with HTTP.Form, 
               "accept" => "application/json"]
    category_type_payload = Dict([
        "projectId" => project_id,
        "text" => text,
        "prefix_key" => prefix_key,
        "suffix_key" => suffix_key,
        "background_color" => background_color,
        "text_color" => text_color
    ])
    r = make_create_category_type_request(url, headers, JSON3.write(category_type_payload))
    return JSON3.read(r.body)
end

function update_category_type(base_url :: String, project_id :: Integer, category_type_id :: Integer, _csrf_token :: String,  text :: String, text_color :: String="#ffffff", background_color :: String="#cdcdcd", prefix_key :: Union{String, Nothing}=nothing, suffix_key :: Union{String, Nothing}=nothing, version :: String="v1")
    url = create_category_type_url(base_url,project_id, version, string(category_type_id))
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json",
               "accept" => "application/json"]

    category_type_payload = Dict([
        "projectId" => project_id,
        "text" => text,
        "prefix_key" => prefix_key,
        "suffix_key" => suffix_key,
        "background_color" => background_color,
        "text_color" => text_color
    ])
    r = make_update_category_type_request(url, headers, JSON3.write(category_type_payload))
    return JSON3.read(r.body)
end

function update_category_type_elements(base_url :: String, project_id :: Integer, category_type_id :: Integer, _csrf_token :: String;  text :: Union{String, Nothing}=nothing, text_color :: Union{String, Nothing}=nothing, background_color :: Union{String, Nothing}=nothing, prefix_key :: Union{String, Nothing}=nothing, suffix_key :: Union{String, Nothing}=nothing, version :: String="v1")
    category_type_detail = get_category_type_detail(base_url, project_id, category_type_id, _csrf_token, version)
    if text == nothing
        text = category_type_detail["text"]
    end
    if text_color == nothing
        text_color = category_type_detail["text_color"]
    end
    if background_color == nothing
        background_color = category_type_detail["background_color"]
    end
    if prefix_key == nothing
        prefix_key = category_type_detail["prefix_key"]
    end
    if suffix_key == nothing
        suffix_key = category_type_detail["suffix_key"]
    end
    return update_category_type(base_url, project_id, category_type_id, _csrf_token, text, text_color, background_color, prefix_key, suffix_key, version)
end

function upload_category_types(base_url :: String, project_id :: Integer, _csrf_token :: String, file_name :: Union{String, Vector{String}}, file_path :: Union{String, Vector{String}}="./", version :: String="v1")
    url = create_category_type_upload_url(base_url, project_id)
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json",
               "accept" => "application/json"]
    files = create_file_paths(file_name, file_path)
    req_responses = []
    for file in files
        file_io = open(file, "r")
        upload_dict = Dict(["file" => read(file_io, String)])
        r = make_category_type_upload_request(url, headers, upload_dict)
        push!(req_responses, JSON3.read(r.body))
    end
    return req_responses
end

function create_project_category_type_pairs(project_ids :: Union{Vector{Integer}, Integer}, category_type_ids :: Union{Vector{Integer}, Integer})
    project_category_type_pairs = []
    if isa(category_type_ids, Vector)
        if length(project_ids) == length(category_type_ids) && isa(project_ids, Vector)
            for (project_id, category_type_id) in zip(project_ids, category_type_ids)
                push!(project_category_type_pairs, project_id => category_type_id)
            end
        else
            if isa(project_ids, Vector)
                for project_id in project_ids
                    category_type_id = category_type_ids[1]
                    push!(project_category_type_pairs, project_id => category_type_id)
                end
            else
                push!(project_category_type_pairs, project_ids => category_type_ids[1])
            end
        end
    else
        if isa(project_ids, Vector)
            for project_id in project_ids
                push!(project_category_type_pairs, project_id => category_type_ids)
            end
        else
            push!(project_category_type_pairs, project_ids => category_type_ids)
        end
    end
    return project_category_type_pairs
end

function delete_category_type(base_url :: String, project_id :: Integer, category_type_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_category_type_url(base_url, project_id, version)
    url = create_category_type_id_url(url, category_type_id)
    headers = ["X-CSRFToken"=>_csrf_token]
    r = make_delete_category_type_request(url, headers)
end

function delete_category_types(base_url :: String, project_ids :: Union{Vector{Integer}, Integer}, category_type_ids :: Union{Vector{Integer}, Integer}, _csrf_token :: String, version :: String="v1")
    for (project_id, category_type_id) in create_project_category_type_pairs(project_ids, category_type_ids)
        delete_category_type(base_url, project_id, category_type_id, _csrf_token, version)
    end
end


#upload_classification_type_name = "label_multi_label_alpha.json"
#upload_classification_type_path = "src"
#base_url = ENV["DOCCANO_BASE_URL"]
#test_project_id = ENV["DOCCANO_TEST_PROJECT_ID"]
#println(upload_category_types(base_url, test_project_id, csrf_token, upload_classification_type_name, upload_classification_type_path))
#println(update_category_type_elements(base_url, test_project_id, 2836, csrf_token, text="julia5", text_color="#ffffff", background_color="#4D64AE"))