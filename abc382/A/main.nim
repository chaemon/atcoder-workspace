when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:int, S:string):
  echo S.count('.') + D
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var S = nextString()
  solve(N, D, S)
else:
  discard

