using Test
using CSV
using DataFrames

import ClaudePrompting.IdCipher as IC
import ClaudePrompting.PrepareData as PD

csv_df = DataFrame("IDs" => [2024194999, 2024194998], "Textdata" => ["Some text here", "Other text here"])
ids_vec = string.(csv_df[!, :IDs])

key = IC.generate_key()
encrypted_df = PD.encrypt_input_data(csv_df, ids_vec, key)



encrypted_ids = [IC.encrypt_id(id, key) for id in ids_vec]
encrypted_df = copy(csv_df)
encrypted_df[!, :IDs] = encrypted_ids

IC.decrypt_id()

encrypted_df

ids_vec_uint8 = [Vector{UInt8(id) for i}]

IC.encrypt_id(ids_vec, 16)

