when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], H:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var H = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    H[i] = nextInt()
  solve(N, X, H)
else:
  discard

