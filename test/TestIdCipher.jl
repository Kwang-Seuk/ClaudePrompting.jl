using Test
using AES
using Random

import ClaudePrompting.IdCipher as IC

@testset "padding test" begin
  @test typeof(IC.pkcs7_pad(UInt64[1, 2, 3], 8)) == Vector{UInt8}
  @test_throws MethodError IC.pkcs7_pad([1, 2, 3], 8)
  @test_throws MethodError IC.pkcs7_pad(UInt64[1, 2, 3], 8.0)
end

plaintext = "2024194001"
key = IC.generate_key()
iv = IC.generate_iv()

IC.encrypt(plaintext, key, iv)
