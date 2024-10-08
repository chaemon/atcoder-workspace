when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, a:seq[int], b:seq[int], d:seq[int], c:seq[int], t:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var d = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
    d[i] = nextInt()
  var c = newSeqWith(K, 0)
  var t = newSeqWith(K, 0)
  for i in 0..<K:
    c[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, K, a, b, d, c, t)
else:
  discard

