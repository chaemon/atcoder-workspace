when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, M:int):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var M = nextInt()
  solve(H, M)
else:
  discard

