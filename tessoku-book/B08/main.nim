when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], Y:seq[int], Q:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
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
  solve(N, X, Y, Q, a, b, c, d)
else:
  discard

