const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, B:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var B = newSeqWith(N-1, nextInt())
  solve(N, B)
else:
  discard

