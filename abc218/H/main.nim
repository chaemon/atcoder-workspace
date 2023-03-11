const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, R:int, A:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var R = nextInt()
  var A = newSeqWith(N-1, nextInt())
  solve(N, R, A)
else:
  discard

