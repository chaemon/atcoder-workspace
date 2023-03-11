const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, Q, a, b, c, d)
else:
  discard

