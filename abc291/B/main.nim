when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int]):
  var X = X.sorted
  echo (X[N ..< 4 * N].sum) / (3 * N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(5*N, nextInt())
  solve(N, X)
else:
  discard

