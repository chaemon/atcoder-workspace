const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(R:int, C:int, sy:int, sx:int, gy:int, gx:int, c:seq[string]):
  discard

when not DO_TEST:
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

