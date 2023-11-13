when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:int, X:int, P:seq[int]):
  for i in N:
    if H + P[i] >= X:
      echo i + 1;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var X = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, H, X, P)
else:
  discard

