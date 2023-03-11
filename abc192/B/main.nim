include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(S:string) =
  for i in S.len:
    if i mod 2 == 0:
      if S[i].ord - 'a'.ord notin 0..<26:
        echo NO;return
    else:
      if S[i].ord - 'A'.ord notin 0..<26:
        echo NO;return
  echo YES
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

