const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"

solveProc solve(S:seq[string], T:seq[string]):
  discard

when not DO_TEST:
  var S = newSeqWith(3, nextString())
  var T = newSeqWith(3, nextString())
  solve(S, T)
else:
  discard

