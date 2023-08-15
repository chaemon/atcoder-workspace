when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
solveProc solve(a:int, b:int, c:int):
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  solve(a, b, c)
else:
  discard

