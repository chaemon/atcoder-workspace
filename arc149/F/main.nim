when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(p:int, q:int, N:int, L:int, R:int):
  discard

when not defined(DO_TEST):
  var p = nextInt()
  var q = nextInt()
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  solve(p, q, N, L, R)
else:
  discard

