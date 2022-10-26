include("DoccanoClient.jl")
include("Projects.jl")
include("utils/Filenames.jl")

function create_url_query(url :: String, url_parameters :: Dict)
    url = URI(url)
    url = URI(url; query=url_parameters)
    return string(url)
end

function get_next_example_batch(example_url :: String, _csrf_token :: String)
    headers = ["X-CSRFToken"=>_csrf_token]
    r = HTTP.request("GET", example_url, headers; cookies = true)
    return JSON3.read(String(r.body)) 
end

function create_example_id_url(base_url :: String, example_id :: Integer, url_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    if url_suffix !== nothing
        return base_url * string(example_id) * raw"/" * url_suffix
    else
        return base_url * string(example_id)
    end 
end

function create_example_upload_url(base_url :: String, project_id :: Integer, version :: String="v1", url_suffix :: Union{String, Nothing}=nothing)
    base_url = create_project_id_url(base_url, "projects", project_id, version)
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    if url_suffix !== nothing
        return base_url * "upload" * raw"/" * url_suffix
    else
        return base_url * "upload"
    end
end

function create_fp_process_url(base_url :: String, version :: String="v1")
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    return base_url * version * raw"/" * "fp/process/"
end

function create_fp_revert_url(base_url :: String, version :: String="v1")
    base_url = if endswith(base_url, raw"/") base_url else base_url * raw"/" end
    return base_url * version * raw"/" * "fp/revert/"
end

function get_examples(base_url :: String, project_id :: Integer, _csrf_token :: String, url_parameters :: Union{Dict, Nothing}=nothing, version :: String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version, "examples")
    if url_parameters !== nothing
        url = create_url_query(url, url_parameters)
    end

    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global examples = JSON3.read(String(readavailable(io)))
        end
    end
    return examples
end

function get_example_detail(base_url :: String, project_id :: Integer, example_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version, "examples")
    url = create_example_id_url(url, example_id)
    println(url)
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global example_detail = JSON3.read(String(readavailable(io)))
        end
    end
    return example_detail
end

function get_all_examples(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    example_arry = []
    example_results = get_examples(base_url, project_id, _csrf_token, nothing, version)
    for example in example_results["results"]
        push!(example_arry, example)
    end
    while example_results["next"] !== nothing
        example_results = get_next_example_batch(example_results["next"], _csrf_token)
        for example in example_results["results"]
            push!(example_arry, example)
        end
    end
    for example in example_results["results"]
        if !(example in example_arry)
            push!(example_arry, example)
        end
    end
    return example_arry
end

function make_create_example_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function make_update_example_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.patch(url, headers, body=user_body; cookies = true)
end

function make_delete_example_request(url :: String, headers:: Vector{Pair{String, String}})
    return HTTP.delete(url, headers; cookies = true)
end

function create_example(base_url :: String, project_id :: Integer, _csrf_token :: String, text :: String,  annotations :: Union{Vector, Nothing}=nothing, annotation_approver :: Union{String, Nothing}=nothing, version :: String="v1")
    if annotations == nothing
        annotations = []
    end
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json", # Comment out with HTTP.Form, 
                "accept" => "application/json"]
    url = create_project_id_url(base_url, "projects", project_id, version)
    example_payload = Dict(["text" => text,
                         "annotations" => annotations,
                         "annotation_approver" => annotation_approver])
    r = make_create_example_request(url, headers, JSON3.write(example_payload))    
    return JSON3.read(r.body)
end

function update_example(base_url :: String, project_id :: Integer, example_id :: Integer, _csrf_token :: String, text :: String,  annotations :: Union{Vector, Nothing}=nothing, annotation_approver :: Union{String, Nothing}=nothing, version :: String="v1")
    url = create_project_id_url(base_url, "projects", project_id, version)
    url = create_example_id_url(url, example_id)
    headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json",
               "accept" => "application/json"]
    example_payload = Dict(["text" => text,
                         "annotations" => annotations,
                         "annotation_approver" => annotation_approver])
    r = make_update_example_request(url, headers, JSON3.write(example_payload))    
    return JSON3.read(r.body)
end

function update_example_elements(base_url :: String, project_id :: Integer, example_id :: Integer, _csrf_token :: String; text :: Union{String, Nothing}=nothing, annotations :: Union{Vector, Nothing}=nothing, annotation_approver :: Union{String, Nothing}=nothing, version :: String="v1")
    example_detail = get_example_detail(base_url, project_id, example_id, _csrf_token, version)
    if text == nothing
        text = example_detail["text"]
    end
    if annotations == nothing
        annotations = example_detail["annotations"]
    end
    if annotation_approver == nothing
        annotation_approver = example_detail["annotation_approver"]
    end
    return update_example(base_url, project_id, example_id, _csrf_token, text, annotations, annotation_approver, version)
end

function make_upload_file_request(url :: String, headers:: Vector{Pair{String, String}}, user_body :: Union{HTTP.Form, String})
    return HTTP.post(url, headers, body=user_body; cookies = true)
end

function make_delete_example_request(url :: String, headers:: Vector{Pair{String, String}})
    return HTTP.delete(url, headers; cookies = true)
end

function make_fp_process_request(url :: String, headers :: Vector{Pair{String, String}}, file_io :: Union{Dict{String, String}, Vector{Pair{String, String}}, HTTP.Form, Union{IOStream, IOBuffer}}, file_name :: String=nothing)
    if isa(file_io, HTTP.Form)
        return HTTP.post(url, headers, body=file_io; cookies = true)
    elseif isa(file_io, IOStream)
        @assert file_name !== nothing
        return HTTP.post(url, headers, body=Dict("filepond"=>HTTP.Multipart(file_name, file_io)); cookies = true)

    elseif isa(file_io, IOBuffer)
        @assert file_name !== nothing
        return HTTP.post(url, headers, body=Dict("filepond"=>HTTP.Multipart(file_name, file_io)); cookies = true)
        
    else
        return HTTP.post(url, headers, JSON3.write(file_io); cookies = true)
    end
end

function make_fp_process_request_with_files(url :: String, headers :: Vector{Pair{String, String}}, files :: Union{Vector{Dict{String, String}}, Vector{HTTP.Form}, Vector{Union{IOStream, IOBuffer}}})
    upload_ids = []
    for file_io in files
        fp_process_request = make_fp_process_request(url, headers, file_io)
        push!(upload_ids, get_upload_id_from_fp_process_request(fp_process_request))
    end
    return upload_ids
end

function get_upload_id_from_fp_process_request(req)
    return String(req.body)
end

function make_fp_revert_request(url :: String, headers :: Vector{Pair{String, String}}, upload_id :: Union{Integer, String})
    return HTTP.delete(url, headers, body=string(upload_id); cookies = true)
end

function make_fp_revert_request_with_upload_ids(url :: String, headers :: Vector{Pair{String, String}}, upload_ids :: Union{Vector{Integer}, Vector{String}})
    for upload_id in upload_ids
        make_fp_revert_request(url, headers, upload_id)
    end
end

function upload_examples(base_url :: String, project_id :: Integer, _csrf_token :: String, file_name :: Union{String, Vector{String}}, file_path :: Union{String, Vector{String}}="./", column_data :: String="text", column_label :: String="label", delimiter :: String="", encoding :: String = "utf_8", format :: String="JSONL", version :: String="v1")
    url = create_example_upload_url(base_url, project_id, version)
    fp_process_url = create_fp_process_url(base_url, version)
    fp_revert_url = create_fp_revert_url(base_url, version)
    headers = ["X-CSRFToken"=>_csrf_token] #, "Content-Type" => "application/json"] #,
               #"accept" => "text/plain"]

    revert_headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "text/plain"]

    if isa(file_name, Vector)
        files = create_file_paths(file_name, file_path)
    else
        files = [file_path * "/" * file_name]
    end

    upload_ids = String[]
    for file in files
        print(file)
        file_io = open(file, "r")
        file_name = create_uploadable_file_name(file)
        file_dict = HTTP.Form(Dict(["filepond" => HTTP.Multipart(file_name, file_io)]))
        #file_dict = Dict(["filepond" => read(file_io, String)])
        #println(file_dict)
        try    
            fp_process_request = make_fp_process_request(fp_process_url, headers, file_dict, file_name)
            upload_id = get_upload_id_from_fp_process_request(fp_process_request)
            push!(upload_ids, upload_id)
        catch e
            rethrow(e)
            for upload_id in upload_ids
                make_fp_revert_request_with_upload_ids(fp_revert_url, revert_headers, upload_id)
            end
        end
    end  

    final_upload_headers = ["X-CSRFToken"=>_csrf_token, "Content-Type" => "application/json",
               "accept" => "application/json"]

    upload_data = Dict([
            "column_data" => column_data,
            "column_label" => column_label,
            "delimiter" => delimiter,
            "encoding" => encoding,
            "format" => format,
            "uploadIds" => upload_ids
            ])
    println(upload_data)
    r = make_upload_file_request(url, final_upload_headers, JSON3.write(upload_data))
    return JSON3.read(r.body)
end

function create_project_example_pairs(project_ids :: Union{Vector{Integer}, Integer}, example_ids :: Union{Vector{Integer}, Integer})
    project_example_pairs = []
    if isa(example_ids, Vector)
        if length(project_ids) == length(example_ids) && isa(project_ids, Vector)
            for (project_id, example_id) in zip(project_ids, example_ids)
                push!(project_example_pairs, project_id => example_id)
            end
        else
            if isa(project_ids, Vector)
                for project_id in project_ids
                    example_id = example_ids[1]
                    push!(project_example_pairs, project_id => example_id)
                end
            else
                push!(project_example_pairs, project_ids => example_ids[1])
            end
        end
    else
        if isa(project_ids, Vector)
            for project_id in project_ids
                push!(project_example_pairs, project_id => example_ids)
            end
        else
            push!(project_example_pairs, project_ids => example_ids)
        end
    end
    return project_example_pairs
end

function delete_example(base_url :: String, project_id :: Integer, example_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_project_id_url(base_url, project_id, version)
    url = create_example_id_url(url, example_id)
    headers = ["X-CSRFToken"=>_csrf_token]
    r = make_delete_example_request(url, headers)
end

function delete_examples(base_url :: String, project_ids :: Union{Vector{Integer}, Integer}, example_ids :: Union{Vector{Integer}, Integer}, _csrf_token :: String, version :: String="v1")
    for (project_id, example_id) in create_project_example_pairs(project_ids, example_ids)
        delete_example(base_url, project_id, example_id, _csrf_token, version)
    end
end

sample_classification_file_name = "sample_classification_inputs.jsonl"
sample_classification_file_path = "src"

#println(upload_examples("http://127.0.0.1", 106, csrf_token, sample_classification_file_name, sample_classification_file_path))