when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string, T:string):
  if T.len < S.len: echo NO
  elif T[0 ..< S.len] == S: echo YES
  else: echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

