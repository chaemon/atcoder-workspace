const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, C:int, B:seq[int], A:seq[seq[int]]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var C = nextInt()
  var B = newSeqWith(M, nextInt())
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, C, B, A)
else:
  discard

