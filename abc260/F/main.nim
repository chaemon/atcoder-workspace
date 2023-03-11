const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:int, T:int, M:int, u:seq[int], v:seq[int]):
  discard

when not DO_TEST:
  var S = nextInt()
  var T = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(S, T, M, u, v)
else:
  discard

