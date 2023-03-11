const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N = nextInt()
  let A = newSeqWith(N, nextInt())
  var v = initTable[int, seq[int]]()
  for i in N:
    if A[i] notin v:
      v[A[i]] = newSeq[int]()
    v[A[i]].add i
  let Q = nextInt()
  for q in Q:
    var L, R, X = nextInt()
    L.dec
    if X notin v:
      echo 0
    else:
      echo v[X].lowerBound(R) - v[X].lowerBound(L)
  discard

when not DO_TEST:
  solve()
else:
  discard

