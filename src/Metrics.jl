#include("DoccanoClient.jl")

function create_metric_url(base_url :: String, endpoint :: String, project_id :: Integer, version :: String="v1", metrix_suffix :: Union{String, Nothing}=nothing)
    base_url = if endswith(base_url, "/") base_url else base_url * "/" end
    base_url = base_url * version * "/"
    if metrix_suffix !== nothing
        return base_url * endpoint * "/" * string(project_id) * "/" * metrix_suffix
    else
        return base_url * endpoint * "/" * string(project_id)
    end 
end

function get_project_progress(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_metric_url(base_url, "projects", project_id, version, "metrics/progress")
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_progress = JSON3.read(String(readavailable(io)))
        end
    end
    return project_progress
end

function get_project_member_progress(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_metric_url(base_url, "projects", project_id, version, "metrics/member-progress")
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_member_progress = JSON3.read(String(readavailable(io)))
        end
    end
    return project_member_progress
end

function get_project_category_distribution(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_metric_url(base_url, "projects", project_id, version, "metrics/category-distribution")
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_category_distribution = JSON3.read(String(readavailable(io)))
        end
    end
    return project_category_distribution
end

function get_project_span_distribution(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_metric_url(base_url, "projects", project_id, version, "metrics/span-distribution")
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_span_distribution = JSON3.read(String(readavailable(io)))
        end
    end
    return project_span_distribution
end

function get_project_relation_distribution(base_url :: String, project_id :: Integer, _csrf_token :: String, version :: String="v1")
    url = create_metric_url(base_url, "projects", project_id, version, "metrics/relation-distribution")
    headers = ["X-CSRFToken"=>_csrf_token]
    HTTP.open("GET", url, headers; cookies = true) do io
        while !eof(io)
            global project_relation_distribution = JSON3.read(String(readavailable(io)))
        end
    end
    return project_relation_distribution
end

#base_url = ENV["DOCCANO_BASE_URL"]
#test_project_id = ENV["DOCCANO_TEST_PROJECT_ID"]
#println(get_project_category_distribution(base_url, test_project_id, csrf_token))