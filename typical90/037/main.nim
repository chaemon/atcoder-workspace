const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/dp/slide_min

solveProc solve(W:int, N:int, L:seq[int], R:seq[int], V:seq[int]):
  var dp = Seq[W + 1: -int.inf]
  dp[0] = 0
  for i in N:
    var u = dp.slideMax(R[i] - L[i] + 1, cut_first = false)
    doAssert u.len == W + 1
    for w in 0 .. W:
      # w - R[i] .. w - L[i]での最大値
      let t = w - L[i]
      if t in 0 ..< u.len and u[t] > -int.inf:
        dp[w].max=u[t] + V[i]
  if dp[W] == -int.inf:
    echo -1
  else:
    echo dp[W]
  return

when not DO_TEST:
  var W = nextInt()
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
    V[i] = nextInt()
  solve(W, N, L, R, V)
