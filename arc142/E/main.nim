const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, a:seq[int], b:seq[int], M:int, x:seq[int], y:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  var M = nextInt()
  var x = newSeqWith(M, 0)
  var y = newSeqWith(M, 0)
  for i in 0..<M:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, a, b, M, x, y)
else:
  discard

