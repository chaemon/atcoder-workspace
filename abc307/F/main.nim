when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, U:seq[int], V:seq[int], W:seq[int], K:int, A:seq[int], D:int, X:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  var W = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
    W[i] = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  var D = nextInt()
  var X = newSeqWith(D, nextInt())
  solve(N, M, U, V, W, K, A, D, X)
else:
  discard

