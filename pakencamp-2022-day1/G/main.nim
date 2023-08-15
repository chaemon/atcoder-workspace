when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], Q:int, X:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  var Q = nextInt()
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, P, Q, X, Y)
else:
  discard

