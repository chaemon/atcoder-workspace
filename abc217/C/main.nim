const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, p:seq[int]):
  var q = newSeq[int](N)
  for i in N:
    q[p[i]] = i
  echo q.mapIt(it + 1).join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var p = newSeqWith(N, nextInt() - 1)
  solve(N, p)
else:
  discard

