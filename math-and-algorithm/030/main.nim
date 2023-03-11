const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, W:int, w:seq[int], v:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var W = nextInt()
  var w = newSeqWith(N, 0)
  var v = newSeqWith(N, 0)
  for i in 0..<N:
    w[i] = nextInt()
    v[i] = nextInt()
  solve(N, W, w, v)
else:
  discard

