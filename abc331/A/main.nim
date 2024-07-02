when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(M:int, D:int, y:int, m:int, d:int):
  shadow y, m, d
  d.inc
  if d > D:
    d = 1
    m.inc
    if m > M:
      m = 1
      y.inc
  echo y, " ", m, " ", d
  discard

when not defined(DO_TEST):
  var M = nextInt()
  var D = nextInt()
  var y = nextInt()
  var m = nextInt()
  var d = nextInt()
  solve(M, D, y, m, d)
else:
  discard

