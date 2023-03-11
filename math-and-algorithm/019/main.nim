const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var ct = Seq[3: 0]
  for a in A:
    ct[a].inc
  ans := 0
  for i in 3:
    ans += (ct[i] * (ct[i] - 1)) div 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A.pred)
else:
  discard

