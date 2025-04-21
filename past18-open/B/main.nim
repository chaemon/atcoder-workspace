when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(R:int, P:int):
  echo int(float(R) * 0.9 + float(P) * 0.1)
  doAssert false
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var P = nextInt()
  solve(R, P)
else:
  discard

