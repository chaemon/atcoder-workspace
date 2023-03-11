const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, B:seq[int], R:seq[int]):
  echo (B.sum + R.sum) / N
  discard

when not DO_TEST:
  var N = nextInt()
  var B = newSeqWith(N, nextInt())
  var R = newSeqWith(N, nextInt())
  solve(N, B, R)
else:
  discard

