const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/graph/warshall_floyd
import lib/other/binary_search

solveProc solve(N:int, P:int, K:int, A:seq[seq[int]]):
  proc calc(X:int):int =
    var A = A
    for i in N:
      for j in N:
        if A[i][j] == -1:
          A[i][j] = X
    var dist = A.warshallFloyd()
    result = 0
    for i in N:
      for j in i + 1 ..< N:
        if dist[i, j] <= P:
          result.inc

  var K0:int
  proc f(X:int):bool =
    return calc(X) >= K0
  if calc(10^9 + 1) == K:
    echo "Infinity";return
  K0 = K
  var i0 = f.maxRight(1 .. P)
  K0 = K + 1
  var i1 = f.maxRight(1 .. P)
  echo i0 - i1
  return

when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, P, K, A)
