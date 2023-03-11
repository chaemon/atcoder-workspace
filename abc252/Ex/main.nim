const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, C:int, K:int, D:seq[int], V:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var C = nextInt()
  var K = nextInt()
  var D = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
    V[i] = nextInt()
  solve(N, C, K, D, V)
else:
  discard

