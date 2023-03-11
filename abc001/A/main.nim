const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(H:seq[int]):
  return

when not DO_TEST:
  var H = newSeqWith(2, nextInt())
  solve(H)
else:
  discard

