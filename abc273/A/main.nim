when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  proc f(n:int):int =
    if n == 0: 1
    else: f(n - 1) * n
  echo f(N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

