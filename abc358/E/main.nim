when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(K:int, C:seq[int]):
  var dp = Seq[K + 1: mint(0)]
  dp[0] = 1
  for i in 26:
    var dp2 = Seq[K + 1: mint(0)]
    for j in 0 .. C[i]:
      for k in 0 .. K:
        if k + j > K: break
        dp2[k + j] += dp[k] * mint.C(k + j, j)
    dp = dp2.move
  echo dp[1 .. K].sum
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var C = newSeqWith(26, nextInt())
  solve(K, C)
else:
  discard

