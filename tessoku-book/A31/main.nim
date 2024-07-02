when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  echo N div 3 + N div 5 - N div 15
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

