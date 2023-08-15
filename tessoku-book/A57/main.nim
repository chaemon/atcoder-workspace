when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, A:seq[int], X:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, Q, A, X, Y)
else:
  discard

