const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int):
  var dp = Array[1..9: mint(1)]
  for i in N - 1:
    var dp2 = Array[1..9: mint(0)]
    for d in 1..9:
      for e in d-1..d+1:
        if e in 1..9:
          dp2[e] += dp[d]
    swap dp, dp2
  echo dp.sum
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

