include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(S:string) =
  for i in 0..<8:
    if i == 3:
      if S[i] != '-': echo NO;return
    else:
      if S[i] notin '0'..'9': echo NO;return
  echo YES
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

