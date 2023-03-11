const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:string):
  if S[^2..^1] == "er":
    echo "er"
  else:
    echo "ist"
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

