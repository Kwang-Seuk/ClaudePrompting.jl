module IdAnonymizer

using DataFrames
using CSV
using Random
using SHA

export anonymize_ids, deanonymize_ids

function get_id_digits(n::Int64)::Int64
  return length(string(n))
end

function anonymize_ids(df::DataFrame)::Tuple{DataFrame,Dict{Int64,String}}
  shuffled_df = df[shuffle(1:nrow(df)), :]

  n = nrow(shuffled_df)
  digits = get_id_digits(n)

  id_map = Dict(
    id => string("S", lpad((parse(Int, bytes2hex(sha256(string(id)))[1:6], base=16) % n) + 1, digits, '0'))
    for id in shuffled_df.IDs
  )

  anonymized_df = DataFrame(
    IDs=[id_map[id] for id in shuffled_df.IDs],
    Ans=shuffled_df.Ans
  )

  return anonymized_df, id_map
end

function deanonymize_ids(
  df::DataFrame, id_map::Dict{Int64,String}
)::DataFrame
  reverse_map = Dict(v => k for (k, v) in id_map)

  deanonymized_df = copy(df)
  deanonymized_df.IDs = [reverse_map[id] for id in df.IDs]

  return deanonymized_df
end

end
