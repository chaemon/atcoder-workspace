when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(T:int, V:int):
  echo T * V
  discard

when not defined(DO_TEST):
  var T = nextInt()
  var V = nextInt()
  solve(T, V)
else:
  discard

