const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(S:string, L:int, R:int):
  if S.len > 1 and S[0] == '0':
    echo NO;return
  elif S.len >= 10:
    echo NO;return
  else:
    let n = S.parseInt
    if n in L..R:
      echo YES
    else:
      echo NO
  return

# input part {{{
when not DO_TEST:
  var S = nextString()
  var L = nextInt()
  var R = nextInt()
  solve(S, L, R)
#}}}

