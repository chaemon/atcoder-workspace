when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, Q:int, K:int, a:seq[int], u:seq[int], v:seq[int], s:seq[int], t:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var K = nextInt()
  var a = newSeqWith(K, nextInt())
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  var s = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, Q, K, a, u, v, s, t)
else:
  discard

