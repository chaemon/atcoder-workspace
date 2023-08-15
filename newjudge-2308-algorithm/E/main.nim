when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, M:int, u:seq[int], v:seq[int], K:int, x:seq[int], y:seq[int], Q:int, p:seq[int], q:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  var K = nextInt()
  var x = newSeqWith(K, 0)
  var y = newSeqWith(K, 0)
  for i in 0..<K:
    x[i] = nextInt()
    y[i] = nextInt()
  var Q = nextInt()
  var p = newSeqWith(Q, 0)
  var q = newSeqWith(Q, 0)
  for i in 0..<Q:
    p[i] = nextInt()
    q[i] = nextInt()
  solve(N, M, u, v, K, x, y, Q, p, q)
else:
  discard

