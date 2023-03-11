include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(S:string) =
  ans := 0
  for i in 0..8:
    if S[i..<i+4] == "ZONe": ans.inc
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

