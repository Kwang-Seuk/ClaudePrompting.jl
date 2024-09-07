module IdCipher

using YAML
using AES
using Random

export generate_key, pkcs7_pad

function generate_iv(block_size::Int64=16)::Vector{UInt8}
  """
  Generate an initial vector for student ID encryption at given block size

  ```julia
  iv = generate_iv(4)
  ```
  4-element Vector{UInt8}:
  0xb0
  0x18
  0x57
  0x9b
  """
  rand(UInt8, block_size)

end

function pkcs7_pad(data::Vector{UInt8}, block_size::Int64)::Vector{UInt8}
  """
  Pad data using PKCS#7 padding. Pads the given data to be a multiple of
  the specified block size using PKCS#7 padding. The padding value is equal
  to the number of bytes added.

  Arguments:
  - `data::Vector{UInt64}`: The original data to be padded in UInt8
  - `block_size::Int64`: The target block size in bytes

  Returns:
  - `Vector{UInt64}`: The padded data

  Example:
  ```julia
  pkcs7_pad(UInt64[1, 2], 8)
  ```
  6-element Vector{UInt8}:
  0x0000000000000006
  0x0000000000000006
  0x0000000000000006
  0x0000000000000006
  0x0000000000000006
  0x0000000000000006
  """

  pad_size = block_size - length(data) % block_size

  return vcat(fill(UInt8(pad_size), pad_size))
end

function generate_key(key_size::Int64=32)::Vector{UInt8}
  """
  Generate a random key for AES encryption
  """
  rand(UInt8, key_size)

end

function encrypt_id(id::String, key::Vector{UInt8})::String
  
  iv = generate_iv()
  padded_id = pkcs7_pad(Vector{UInt8.(id)}, 16)
end

end
