const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(N:int, M:int, S:seq[int], T:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextInt())
  var T = newSeqWith(M, nextInt())
  solve(N, M, S, T)

