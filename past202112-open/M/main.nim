when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, S:seq[string], X:seq[int], T:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var S = newSeqWith(N, nextString())
  var X = newSeqWith(Q, 0)
  var T = newSeqWith(Q, "")
  for i in 0..<Q:
    X[i] = nextInt()
    T[i] = nextString()
  solve(N, Q, S, X, T)
else:
  discard

