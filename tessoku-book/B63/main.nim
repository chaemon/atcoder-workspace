when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(R:int, C:int, sy:int, sx:int, gy:int, gx:int, c:seq[string]):
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var C = nextInt()
  var sy = nextInt()
  var sx = nextInt()
  var gy = nextInt()
  var gx = nextInt()
  var c = newSeqWith(R, nextString())
  solve(R, C, sy, sx, gy, gx, c)
else:
  discard

