const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string, T:string):
  if S == T: echo YES;return
  for i in 0..<S.len - 1:
    var S = S
    swap S[i], S[i + 1]
    if S == T: echo YES;return
  echo NO
  return

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

