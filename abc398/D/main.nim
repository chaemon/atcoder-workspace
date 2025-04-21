when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, R:int, C:int, S:string):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var R = nextInt()
  var C = nextInt()
  var S = nextString()
  solve(N, R, C, S)
else:
  discard

