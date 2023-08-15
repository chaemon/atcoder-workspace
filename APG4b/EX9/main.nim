when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(x:int, a:int, b:int):
  discard

when not defined(DO_TEST):
  var x = nextInt()
  var a = nextInt()
  var b = nextInt()
  solve(x, a, b)
else:
  discard

