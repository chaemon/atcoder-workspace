when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var c = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  for i in 0..<Q:
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, M, a, b, Q, c, d)
else:
  discard

