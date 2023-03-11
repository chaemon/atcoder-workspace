when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int):
  let
    b = N div 10
    a = N mod 10
  if a == b: echo 1
  else: echo 0
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

