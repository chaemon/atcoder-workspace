when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int, K:int):
  var X = X
  for i in 0 .. K - 1:
    let
      d = 10^(i + 1)
      h = d div 2
    X = (X + h) div d * d
  echo X
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var K = nextInt()
  solve(X, K)
else:
  discard

