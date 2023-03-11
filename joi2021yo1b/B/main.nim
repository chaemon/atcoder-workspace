include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, S:string) =
  for i in 0..<N:
    for j in i + 1..<N:
      for k in j + 1..<N:
        if S[i] == 'I' and S[j] == 'O' and S[k] == 'I':
          echo YES
          return
  echo NO
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}
