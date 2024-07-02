when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(L:int, R:int):
  discard

when not defined(DO_TEST):
  var L = nextInt()
  var R = nextInt()
  solve(L, R)
else:
  discard

