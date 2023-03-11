const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var t = initTable[int, int]()
  for a in A:
    if a notin t: t[a] = 0
    t[a].inc
  var
    ans = -1
    min_ct = int.inf
  for k, v in t:
    if v < min_ct: min_ct = v; ans = k
    elif v == min_ct: ans.min=k
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

