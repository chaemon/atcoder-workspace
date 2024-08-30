when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, f:seq[int], t:seq[int], c:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var f = newSeqWith(M, 0)
  var t = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    f[i] = nextInt()
    t[i] = nextInt()
    c[i] = nextInt()
  solve(N, M, K, f, t, c)
else:
  discard

