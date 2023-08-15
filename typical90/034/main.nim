const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, K:int, a:seq[int]):
  var
    t = initTable[int, int]()
    j = 0
    ans = 0
  for i in N:
    while j < N:
      if t.len == K and a[j] notin t: break
      if a[j] notin t:
        t[a[j]] = 0
      t[a[j]].inc
      j.inc
    ans.max= j - i
    t[a[i]].dec
    if t[a[i]] == 0: t.del a[i]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
