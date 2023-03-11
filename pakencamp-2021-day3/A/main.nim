const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:seq[string]):
  ans := 0
  for s in S:
    if s == "1111": ans.inc
  echo ans
  discard

when not DO_TEST:
  var S = newSeqWith(4, nextString())
  solve(S)
else:
  discard

