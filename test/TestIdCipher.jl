using Test
using AES 
using Random 

import ClaudePrompting.IdCipher as IC 

key = IC.generate_key()
id = "2024194999"
encrypted_id = IC.encrypt_id(id, key)
IC.decrypt_id(encrypted_id, key)
