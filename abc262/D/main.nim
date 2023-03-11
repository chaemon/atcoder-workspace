const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, a:seq[int]):
  ans := mint(0)
  for c in 1 .. N:
    var dp = newSeqWith(c, newSeqWith(c + 1, mint(0)))# Seq[c, c + 1: mint(0)] # remaider, number
    dp[0][0] = 1
    for i in N:
      dp2 := dp
      for r in c:
        for t in 0 ..< c:
          let r2 = (r + a[i]) mod c
          dp2[r2][t + 1] += dp[r][t]
      swap dp, dp2
    ans += dp[0][c]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

