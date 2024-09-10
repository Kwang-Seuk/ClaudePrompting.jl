module PrepareData

using CSV
using DataFrames
using AES

import ClaudePrompting.IdCipher as IC
export encrypt_input_data

function encrypt_input_data(df::DataFrame, ids_vec::Vector{String}, key::AES.AES128Key) 
  encrypted_ids = [IC.encrypt_id(id, key) for id in ids_vec]
  encrypted_df = copy(df)
  encrypted_df[!, :IDs] = encrypted_ids

  return encrypted_df
end



end
