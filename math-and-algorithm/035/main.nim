const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(x:seq[int], y:seq[int], r:seq[int]):
  discard

when not DO_TEST:
  var x = newSeqWith(2, 0)
  var y = newSeqWith(2, 0)
  var r = newSeqWith(2, 0)
  for i in 0..<2:
    x[i] = nextInt()
    y[i] = nextInt()
    r[i] = nextInt()
  solve(x, y, r)
else:
  discard

