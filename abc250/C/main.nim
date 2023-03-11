const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, x:seq[int]):
  var a, pos = (0..<N).toSeq
  for i in N: pos[i] = i
  for q in Q:
    let i = pos[x[q]]
    var j = if i == N - 1: N - 2 else: i + 1
    pos[a[i]] = j
    pos[a[j]] = i
    swap a[i], a[j]
  for i in N: a[i].inc
  echo a.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, nextInt() - 1)
  solve(N, Q, x)
else:
  discard

