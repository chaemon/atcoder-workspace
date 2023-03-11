when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, K:int, u:seq[int], v:seq[int], a:seq[int], s:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var a = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    a[i] = nextInt()
  var s = newSeqWith(K, nextInt())
  solve(N, M, K, u, v, a, s)
else:
  discard

