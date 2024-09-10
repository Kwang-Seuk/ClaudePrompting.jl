using DataFrames
using YAML
using PromptingTools

import ClaudePrompting.IdCipher as IC
import ClaudePrompting.PrepareData as PD
import ClaudePrompting.CommunicateClaude as CC

# 1. Prepare your data with students' IDs encryption

df = DataFrame(
  IDs = [2024194998, 2024194999],
  Textdata = ["1. 세포는 핵막으로 둘러싸인 핵이 있지만, 세균은 핵이 없습니다. 2. 세포는 미토콘드리아, 소포체 등 다양한 막성 소기관들이 존재하지만, 세균은 리보솜 같은 단순한 소기관만 존재합니다. 3. 세포가 일반적으로 세균보다 크기가 큽니다. - 이중에서 저는 세포와 세균의 핵의 유무가 가장 중요한 차이점이라고 생각합니다. 세포는 진핵세포, 세균은 원핵세포로서 핵은 생명체를 구성하는 요인 중 가장 중요한 부분이라고 생각하기 때문입니다.", "차이점은 바이러스는 핵이 없고,숙주가 없다면 생명활동을 하지않으며 전염력이 발생한다는 점입니다. 가장 중요한것은 생명활동을 숙주가 없다면 하지않는 것이라고 생각합니다.왜냐하면 우리몸은 꾸준히 죽지않는 이상 생명활동을 지속하지만 바이러스는 숙주가 없다면 생명활동을 하지않기 때문입니다."]
)
ids_vec = string.(df[!, :IDs])
key = IC.generate_key()
encrypted_df = PD.encrypt_input_data(df, ids_vec, key)

# 2. Convert the DataFrame into YAML format

key_order = [:IDs, :Textdata]
yml_data = PD.df_to_yml(encrypted_df, key_order)
yml_string = YAML.yaml(yml_data)

# 3. Setup Claude connection

api_filepath = "/home/kjeong/.config/anthropic/anthropic_api_key"
CC.set_anthropic_api_key(api_filepath)

# 4. Communicate with Claude

prompt = "저는 간호대학생에게 infectious microbiology를 가르치고 있습니다. 제가 학생들을 대상으로 진행한 퀴즈 문제의 응답을 분석하여 상중하로 평가하고, 학생 개인 맞춤형으로 학습을 지원하는 메시지를 작성하고자 합니다. 아래는 제가 진행한 퀴즈에 대한 정보입니다.
(1) 퀴즈_문제: 사람의 몸을 구성하는 세포와 질병을 유발하는 세균을 비교해서 구조적 차이점을 3가지 적고, 본인은 그 중에서 어떤 면이 가장 중요한 차이점인지 그 이유와 함께 설명해 보세요. (2) 퀴즈의_목적: 세균의 구조와 진핵세포의 구조간 차이를 정확하게 이하하는지 여부를 점검하고, 중요한 차이점에 대해 자신의 생각을 적절히 적을 수 있는지 점검. (3) 답안_예시: 1. 세포벽: 사람 세포에는 없고 세균에만 있음, 2. 핵막: 사람 세포에는 있고 세균에는 없음, 3. 세포 크기: 사람 세포가 세균보다 훨씬 큼, 가장 중요한 차이점은 세포벽입니다. 세포벽은 세균에게 구조적 안정성을 제공하고 항생제 표적이 되므로, 감염미생물학 관점에서 중요한 차이점입니다. (4) 평가기준: 상: 진핵세포와 원핵세포의 차이점 3가지를 정확하게 적고, 중요한 차이점을 논리적으로 기술하였다, 중: 진핵세포와 원핵세포의 차이점을 1-2가지 적고, 중요한 차이점을 간략하게 기술하였다, 하: 차이점을 1가지 혹은 적지 못하거나, 중요한 차이점을 설명하지 못하였다, 혹은 무응답. 퀴즈 문제에 대한 위 특성을 확인해서 기억해 주세요.
  함께 제공하는 yml 데이터는 각 학생들의 응답입니다. 이 응답에 대해서 다음과 같은 결과를 저에게 yml 형식으로 제공해 주세요.
- SN: 학생 ID
  Achievement: 학생의 응답을 평가기준에 따라 평가한 결과
  Suggestion: 학생의 응답을 기초해서 그 학생에게 제안할 학습 방향과 주요 주제 등 메세지 작성
  Writing_ability: 질문에 대해 내용을 적절하게 작성할 수 있는 능력 평가 결과를 학생의 응답에 따라 평가하고 그렇게 평가한 이유를 작성
  Remarks: 교수가 해당 학생에 대해 기억해 둬야 할 사항들 작성"


response = CC.provide_yml_to_claude(yml_string, prompt)
result = unescape_string(response)
open("result.txt", "w") do io
  write(io, result)
end

yml_result_filepath = "/home/kjeong/localgit/ClaudePrompting.jl/result.txt"
yml_output = read(yml_result_filepath, String)
col_names = ["SN", "Achievement", "Suggestion", "Writing_ability", "Remarks"]
result_df = CC.yml_res_to_dataframe(yml_output, col_names)
