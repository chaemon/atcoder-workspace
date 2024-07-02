when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, a:seq[int], b:seq[int], c:seq[int], u:seq[int], v:seq[int], w:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  var c = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  var w = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  solve(N, Q, a, b, c, u, v, w)
else:
  discard

