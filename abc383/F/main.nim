when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, K:int, P:seq[int], U:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, 0)
  var U = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    U[i] = nextInt()
    C[i] = nextInt()
  solve(N, X, K, P, U, C)
else:
  discard

