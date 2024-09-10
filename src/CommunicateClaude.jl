module CommunicateClaude

using PromptingTools
using YAML
using DataFrames
using JSON3
using HTTP

export set_anthropic_api_key, provide_yml_to_claude, yml_res_to_dataframe

function set_anthropic_api_key(filepath::String)
  if isfile(filepath)
    api_key = strip(read(filepath, String))
    PromptingTools.set_preferences!("ANTHROPIC_API_KEY" => api_key)
    println("Anthropic API Key is successfully set.")
  else
    error("API key file not found.")
  end
end

function provide_yml_to_claude(yml_string::String, prompt::String)
  api_key = PromptingTools.get_preferences("ANTHROPIC_API_KEY")
  headers = [
    "Content-Type" => "application/json",
    "x-api-key" => api_key,
    "anthropic-version" => "2023-06-01"
  ]
  body = JSON3.write(Dict(
    #"model" => "claude-3-haiku-20240307", 
    "model" => "claude-3-5-sonnet-20240620",
    "max_tokens" => 4000,
    "messages" => [
      Dict("role" => "user", "content" => "Here is some data in DataFrame format:\n\n$yml_string\n\n$prompt")
    ]
  ))
  response = HTTP.post("https://api.anthropic.com/v1/messages", headers, body)
  response_body = JSON3.read(String(response.body))

  if haskey(response_body, :content) && length(response_body.content) > 0
    return response_body.content[1].text
  else
    error("Unexpected response structure from Claude API")
  end

end

function yml_res_to_dataframe(
  yml_result::String, col_names::Vector{String}
)::DataFrame
  data = YAML.load(yml_result)
  df = DataFrame(
    [Dict(col => get(entry, col, missing) for col in col_names)
     for entry in data]
  )
  df = select!(df, col_names)

  return df
end

end
