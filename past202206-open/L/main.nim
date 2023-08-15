when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, T:string, K:int):
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  var K = nextInt()
  solve(S, T, K)
else:
  discard

