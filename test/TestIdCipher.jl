using Test
using AES 
using Random 

import ClaudePrompting.IdCipher as IC 

@testset "PKCS7 padding test" begin
  vec1 = Vector{UInt8}("123")
  vec1_UInt8 = [0x31, 0x32, 0x33]
  test_padded_data1 = IC.pad_pkcs7(vec1, 16)
  @test test_padded_data1[1:3] == vec1_UInt8
  @test length(test_padded_data1) == 16
  @test typeof(test_padded_data1) == Vector{UInt8}

  vec2 = [123] 
  vec2_uint8 = Vector{UInt8}([123])
  @test_throws MethodError IC.pad_pkcs7(vec2, 16)
end
