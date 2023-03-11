const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int):
  var dp = Seq[N + 1, N + 1: Option[mint]]
  proc calc(k, s:int):mint =
    if k < 0 or s < 0: return mint(0)
    if dp[k][s].isSome: return dp[k][s].get
    if k == 0:
      if s == 0:
        result = 1
      else:
        result = 0
    else:
      result = 0
      result += calc(k, s - k)
      result += calc(k - 1, s - 1)
      result -= calc(k - 1 - M, (s - 1) - (k - 1))
    dp[k][s] = result.some
  for k in 1..N:
    echo calc(k, N)
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

