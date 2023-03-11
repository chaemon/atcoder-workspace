const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var ct = initTable[int, int]()
  for i in N:
    ct[A[i]].inc
  ans := 0
  for k, v in ct:
    if k * 2 < 100000:
      let t = 100000 - k
      if t in ct:
        ans += v * ct[t]
    elif k * 2 == 100000:
      ans += v * (v - 1) div 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

