const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var ans = 0
  var ct = initTable[int, int]()
  for a in A:
    if a notin ct: ct[a] = 0
    ct[a].inc
  for s in B.toSet():
    if s in ct:
      ans += ct[s]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
else:
  discard

