const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import macros

#template `B`(b:untyped):auto = b

solveProc solve(N:int, D:int, p:seq[int], q:seq[int]):
  var dp = Seq[D + 1, D + 1: mint(0)]
  dp[0][0] = 1
  var cs0, cs1 = Seq[D * 2 + 1: DualCumulativeSum[mint]]
  for i in N:
    for j in D * 2 + 1:
      cs0[j].init()
      cs1[j].init()
    var
      dp2 = Seq[D + 1, D + 1: mint(0)]
      d = abs(p[i] - q[i])
    # cs0: x + y, (x - y + D) / 2
    # cs1: x - y + D, (x + y) / 2
    for x in 0 .. D:
      for y in 0 .. D:
        if dp[x][y] == 0: continue
        #  i = x + y
        #  j = (x - y + D) / 2
        # p < r < qの場合
        # dp[x][y]がdp[x + t][y + d - t]に足す(1 <= t <= d - 1)
        # つまりi = x + y + d, j = (x - y + 2t - d + D) / 2
        block:
          var
            i = x + y + d
            jmin = (x - y + 2 * 1 - d + D) shr 1
            jmax = (x - y + 2 * (d - 1) - d + D) shr 1
          jmin.max= 0
          jmax.min= D * 2
          if jmin <= jmax and i in 0 .. D * 2:
            cs0[i].add(jmin .. jmax, dp[x][y])
        # r <= pの場合
        # dp[x][y]がdp[x + t][y + d + t]に足す(0 <= t < D)
        # つまりi = (x + y + 2t + d) / 2, j = x - y - d + D
        block:
          var
            imin = (x + y + 2 * 0 + d) shr 1
            imax = (x + y + 2 * D + d) shr 1
            j = x - y - d + D
          imin.max= 0
          imax.min= D * 2
          if imin <= imax and j in 0 .. D * 2:
            cs1[j].add(imin .. imax, dp[x][y])
        # q <= rの場合
        # dp[x][y]がdp[x + d + t][y + t]に足す(0 <= t < D)
        # つまりi = (x + y + 2t + d) / 2, j = x - y + d + D
        block:
          var
            imin = if d > 0:
              (x + y + 2 * 0 + d) shr 1
            else:
              (x + y + 2 * 1 + d) shr 1
            imax = (x + y + 2 * D + d) shr 1
            j = x - y + d + D
          imin.max= 0
          imax.min= D * 2
          if imin <= imax and j in 0 .. D * 2:
            cs1[j].add(imin .. imax, dp[x][y])
    for x in 0 .. D:
      for y in 0 .. D:
        dp2[x][y] += cs0[x + y][(x - y + D) shr 1]
        dp2[x][y] += cs1[x - y + D][(x + y) shr 1]
    dp = dp2.move()
    #debug dp
  ans := mint(0)
  for x in 0 .. D:
    for y in 0 .. D:
      ans += dp[x][y]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var p = newSeqWith(N, nextInt())
  var q = newSeqWith(N, nextInt())
  solve(N, D, p, q)
else:
  discard

