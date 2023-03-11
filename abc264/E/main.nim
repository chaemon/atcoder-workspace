const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/dsu

solveProc solve(N:int, M:int, E:int, U:seq[int], V:seq[int], Q:int, X:seq[int]):
  d := initDSU(N + M)
  for u in N ..< N + M - 1: d.merge(u, u + 1)
  var isEvent = Seq[E: false]
  for q in Q:
    isEvent[X[q]] = true
  for i in E:
    if not isEvent[i]: d.merge(U[i], V[i])
  ans := Seq[int]
  for i in (0 ..< Q) << 1:
    ans.add d.size(N) - M
    d.merge(U[X[i]], V[X[i]])
  ans.reverse
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var E = nextInt()
  var U = newSeqWith(E, 0)
  var V = newSeqWith(E, 0)
  for i in 0..<E:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  var Q = nextInt()
  var X = newSeqWith(Q, nextInt() - 1)
  solve(N, M, E, U, V, Q, X)
else:
  discard

