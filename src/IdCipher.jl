module IdCipher

using YAML
using AES
using Random

export generate_key, pkcs7_pad, encrypt

function generate_iv(block_size::Int64=16)::Vector{UInt8}
  rand(UInt8, block_size)

end

function pkcs7_pad(data::Vector{UInt8}, block_size::Int64)::Vector{UInt8}
  pad_size = block_size - length(data) % block_size

  return vcat(fill(UInt8(pad_size), pad_size))
end

function generate_key(key_size::Int64=32)::Vector{UInt8}
  rand(UInt8, key_size)

end

function encrypt(
  plaintext::String, key::Vector{UInt8}, iv::Vector{UInt8}
)::Vector{UInt8}
  plaintext_bytes = Vector{UInt8}(plaintext)
  padded_plaintext = pkcs7_pad(plaintext_bytes, 16)
  cipher_bytes = AESCBC(padded_plaintext, key, iv, true)

  return bytes2hex(cipher_bytes)
end

end
