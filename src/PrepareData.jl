module PrepareData

using CSV
using DataFrames
using AES
using OrderedCollections

import ClaudePrompting.IdCipher as IC
export encrypt_input_data, df_to_yml

function encrypt_input_data(df::DataFrame, ids_vec::Vector{String}, key::AES.AES128Key) 
  encrypted_ids = [IC.encrypt_id(id, key) for id in ids_vec]
  encrypted_df = copy(df)
  encrypted_df[!, :IDs] = encrypted_ids

  return encrypted_df
end

function df_to_yml(df::DataFrame, key_order::Vector{Symbol})::Vector{Any}
  yml_data = []
  for row in eachrow(df) 
    ordered_dict = OrderedDict(key => row[key] for key in key_order) 
    push!(yml_data, ordered_dict)
  end
  return yml_data
end

end
