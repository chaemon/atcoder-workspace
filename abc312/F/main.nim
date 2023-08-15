when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, T:seq[int], X:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var T = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    X[i] = nextInt()
  solve(N, M, T, X)
else:
  discard

