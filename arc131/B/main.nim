const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, c:seq[string]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var c = newSeqWith(H, nextString())
  solve(H, W, c)
else:
  discard

