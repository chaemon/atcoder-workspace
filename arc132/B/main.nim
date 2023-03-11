const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(n:int, p:seq[int]):
  discard

when not DO_TEST:
  var n = nextInt()
  var p = newSeqWith(n, nextInt())
  solve(n, p)
else:
  discard

