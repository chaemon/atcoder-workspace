when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int, N:int):
  var
    ct = 0
    X = X
  while X < N:
    let r = X mod 3
    if r == 0:
      X += 1
    else:
      X *= r + 1
    ct.inc
  echo ct
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var N = nextInt()
  solve(X, N)
else:
  discard


