when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], Y:seq[int], Z:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  var Z = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
    Z[i] = nextInt()
  solve(N, X, Y, Z)
else:
  discard

