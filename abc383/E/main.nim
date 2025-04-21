when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, u:seq[int], v:seq[int], w:seq[int], A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var w = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  var A = newSeqWith(K, nextInt())
  var B = newSeqWith(K, nextInt())
  solve(N, M, K, u, v, w, A, B)
else:
  discard

