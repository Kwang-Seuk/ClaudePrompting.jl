module IdCipher

using YAML
using AES
using Random

export generate_key, encrypt_id, decrypt_id

function generate_key()
  return AES128Key(rand(UInt8, 16))
end

function pad_pkcs7(data::Vector{UInt8}, block_size::Int64)
  padding_length = block_size - (length(data) % block_size)
  padding = fill(UInt8(padding_length), padding_length)
  return vcat(data, padding)
end


function encrypt_id(id::String, key::AES128Key)
  cipher = AESCipher(; key_length=128, mode=AES.CBC, key=key)
  id_bytes = Vector{UInt8}(id)
  padded_id = pad_pkcs7(id_bytes, 16)
  encrypted = encrypt(padded_id, cipher)
  encrypted_data = encrypted.data
  return bytes2hex(encrypted_data)
end


function decrypt_id(encrypted_id::String, key::AES128Key)
  cipher = AESCipher(; key_length=128, mode=AES.CBC, key=key)
  encrypted_bytes = hex2bytes(encrypted_id)
  iv = encrypted_bytes[1:16]
  ciphertext = encrypted_bytes[17:end]
  decrypted = decrypt(AES.CipherText(ciphertext, iv, AES.CBC), cipher)
  unpadded = unpad_pkcs7(decrypted)
  return String(unpadded)
end
end
