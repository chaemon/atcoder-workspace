const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

const B = 210

var
  dp = Array[B * 2, B * 2: int]
  vis = Array[B * 2, B * 2: false]

solveProc solve(N:int, A:seq[int]):
  proc calc(i, j: int):int =
    if vis[i][j]: return dp[i][j]
    vis[i][j] = true
    r =& dp[i][j]
    r = int.inf
    if i == j: r = 0
    else:
      for k in i + 2 .. j >> 2:
        # i ..< kについて
        # i + 1 ..< k - 1を消して
        # A[i]とA[k - 1]を消す
        let d = min(min(calc(i + 1, k - 1) + calc(k, j), int.inf) + abs(A[i] - A[k - 1]), int.inf)
        r.min= d
    return r
  echo calc(0, N * 2)
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(2*N, nextInt())
  solve(N, A)
