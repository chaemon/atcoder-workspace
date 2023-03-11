const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, D:int, r:seq[int], s:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var D = nextInt()
  var r = newSeqWith(M+1, nextInt())
  var s = newSeqWith(M, nextInt())
  solve(N, M, D, r, s)
else:
  discard

