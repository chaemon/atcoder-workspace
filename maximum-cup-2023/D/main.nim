when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(K:int, S:string):
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var S = nextString()
  solve(K, S)
else:
  discard

