const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int], M:int, B:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-1, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  solve(N, A, M, B)
else:
  discard

