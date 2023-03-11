const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(N:int, M:int, p:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var p = newSeqWith(N+M, nextInt())
  solve(N, M, p)

