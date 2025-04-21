when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int, H:int, M:int):
  var (H, M) = (H, M)
  if M < X:
    echo X - M
  else:
    echo X - M + 60
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var H = nextInt()
  var M = nextInt()
  solve(X, H, M)
else:
  discard

