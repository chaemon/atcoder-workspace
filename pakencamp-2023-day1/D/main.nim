when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(K:int, X:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var X = newSeqWith(2, 0)
  var Y = newSeqWith(2, 0)
  for i in 0..<2:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(K, X, Y)
else:
  discard

