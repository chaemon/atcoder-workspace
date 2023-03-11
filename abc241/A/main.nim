const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(a:seq[int]):
  echo a[a[a[0]]]
  discard

when not DO_TEST:
  var a = newSeqWith(9+1, nextInt())
  solve(a)
else:
  discard

