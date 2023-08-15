when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], X:seq[int], Y:seq[int], Z:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  var Z = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
    Z[i] = nextInt()
  solve(N, M, A, X, Y, Z)
else:
  discard

