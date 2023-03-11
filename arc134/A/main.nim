const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, L:int, W:int, a:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var W = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, L, W, a)
else:
  discard

