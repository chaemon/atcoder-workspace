const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  for s in S:
    if S.count(s) == 1:
      echo s;return
  echo -1
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

