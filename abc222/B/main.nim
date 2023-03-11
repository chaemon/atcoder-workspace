const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, P:int, a:seq[int]):
  var ans = 0
  for a in a:
    if a < P: ans.inc
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, P, a)
else:
  discard

