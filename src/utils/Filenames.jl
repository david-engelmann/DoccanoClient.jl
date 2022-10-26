using URIs

function create_file_paths(file_names :: Union{String, Vector{String}}, file_path :: Union{String, Vector{String}})
    file_paths = []
    if isa(file_names, Vector) && isa(file_path, Vector)
        number_of_names = length(file_names)
        number_of_paths = length(file_path)
        if number_of_names == number_of_paths
            println("zip file and path")
            for (path, name) in zip(file_path, file_names)
                push!(file_paths, string(URI(path * raw"/" *  name)))
            end
        
        elseif number_of_paths == 1
            path = file_path[1]
            for name in file_names
                push!(file_paths, string(URI(path * raw"/" *  name)))
            end

        elseif number_of_names < number_of_paths
            println("file_name is shorter than file_path (length(Vector{String})) ------ length(file_name) = $(number_of_names) ----- length(file_path) = $(number_of_paths)")

        else
            path = file_path[1]
            for name in file_names
                push!(file_paths, string(URI(path * raw"/" *  name)))
            end
        end
    elseif isa(file_names, Vector) && isa(file_path, String)
        path = file_path
        for name in file_names
            push!(file_paths, string(URI(path * raw"/" *  name)))
        end
    
    elseif isa(file_names, String) && isa(file_path, Vector)
        file_names = [file_names for _ in 1:length(file_path)]
        println("zip file and path")
        for (path, name) in zip(file_path, file_names)
                push!(file_paths, string(URI(path * raw"/" *  name)))
            end

    else
        path = file_path
        name = file_names
        push!(file_paths, string(URI(path * raw"/" *  name)))   

    end
    return file_paths
end

function create_uploadable_file_name(file_name)
    file_uri = URI(file_name)
    return String(last(split(file_uri.path, "/")))
end

println(create_uploadable_file_name("src/sample_classification_inputs.jsonl"))