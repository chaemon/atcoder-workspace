const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, a:seq[int], b:seq[int], A:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, a, b, A)
else:
  discard

