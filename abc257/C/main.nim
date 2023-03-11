const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string, W:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  var W = newSeqWith(N, nextInt())
  solve(N, S, W)
else:
  discard

