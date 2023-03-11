const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(S:string):
  if S[0] == S[1] and S[1] == S[2]:
    echo 1
  elif S[0] == S[1] or S[1] == S[2] or S[2] == S[0]:
    echo 3
  else:
    echo 6
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

