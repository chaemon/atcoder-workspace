const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int], u:seq[int], v:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-2+1, nextInt())
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, A, u, v)
else:
  discard

