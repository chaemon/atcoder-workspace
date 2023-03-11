when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int):
  for i in countdown(N, 0):
    echo i
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

