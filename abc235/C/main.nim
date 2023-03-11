const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, a:seq[int], x:seq[int], k:seq[int]):
  var t = initTable[int, seq[int]]()
  for i in N:
    if a[i] notin t: t[a[i]] = newSeq[int]()
    t[a[i]].add(i)
  for i in Q:
    if x[i] notin t or t[x[i]].len <= k[i]:
      echo -1
    else:
      echo t[x[i]][k[i]] + 1
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N, nextInt())
  var x = newSeqWith(Q, 0)
  var k = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    k[i] = nextInt() - 1
  solve(N, Q, a, x, k)
else:
  discard

