const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header
import lib/other/bitutils
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(K:int, N:int, x:seq[int]):
  let X = x[^1] + N
  dp := Seq[2^K, 2: mint(0)] # bit, parity
  dp[0][0] = 1
  for y in 0..X:
    dp2 := dp
    for b in 2^K:
      for p in 0..1:
        var c = 0
        for i in K:
          if b[i] == 0:
            # x[i] -> y
            let d = y - x[i]
            if d >= 0:
              dp2[b xor [i]][(p + c) mod 2] += dp[b][p] * mint.C(N, d)
            c.inc
    swap dp, dp2
  echo (dp[2^K - 1][0] - dp[2^K - 1][1]) / mint(2)^(K * N)
  return

when not DO_TEST:
  var K = nextInt()
  var N = nextInt()
  var x = newSeqWith(K, nextInt())
  solve(K, N, x)

