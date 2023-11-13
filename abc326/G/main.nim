when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/maxflow

solveProc solve(N:int, M:int, C:seq[int], A:seq[int], L:seq[seq[int]]):
  var L = L
  for i in L.len:
    for j in L[i].len:
      L[i][j].dec
  var
    g = initMaxFlow[int](5 * N + M + 2)
    S = A.sum
  let
    s = 5 * N + M
    t = s + 1
    INF = int.high
  proc id(i, j:int):int =
    i * 5 + j
  for i in N:
    for j in 4:
      g.addEdge(id(i, j + 1), id(i, j), INF)
      g.addEdge(id(i, j + 1), t, C[i])
  for k in M:
    let p = 5 * N + k
    g.addEdge(s, p, A[k])
    for i in N:
      g.addEdge(p, id(i, L[k][i]), INF)
  echo S - g.flow(s, t)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var C = newSeqWith(N, nextInt())
  var A = newSeqWith(M, nextInt())
  var L = newSeqWith(M, newSeqWith(N, nextInt()))
  solve(N, M, C, A, L)
else:
  discard

