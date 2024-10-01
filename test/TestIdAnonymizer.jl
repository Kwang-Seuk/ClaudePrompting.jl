using Test
using DataFrames
using Random

import ClaudePrompting.IdAnonymizer as IA 

@testset "IdAnonymizer test" begin
  test_df1 = DataFrame(IDs=collect(1:2), Ans=rand(Bool, 2))
  anonymized_df1, id_map1 = IA.anonymize_ids(test_df1)
  @test all(length.(anonymized_df1.IDs) .== 2)
  @test all(length.(values(id_map1)) .== 2) 

  test_df2 = DataFrame(IDs=collect(1:10), Ans=rand(Bool, 10))
  anonymized_df2, id_map2 = IA.anonymize_ids(test_df2)
  @test all(length.(anonymized_df2.IDs) .== 3)
  @test all(length.(values(id_map2)) .== 3) 

  test_df3 = DataFrame(IDs=["1", "2"], Ans=rand(Bool, 2))
  @test_throws MethodError IA.anonymize_ids(test_df3)
end
