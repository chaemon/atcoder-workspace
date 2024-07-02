when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(a:int, b:int, C:int):
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var C = nextInt()
  solve(a, b, C)
else:
  discard

