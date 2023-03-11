const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, a:seq[int]):
  var
    t = 0
    ans = 0
  for i in N:
    if a[i] == i: t.inc
    elif i < a[i]:
      let j = a[i]
      if max(a[i], a[j]) == j and min(a[i], a[j]) == i: ans.inc
  ans += (t * (t - 1)) div 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt() - 1)
  solve(N, a)
else:
  discard

