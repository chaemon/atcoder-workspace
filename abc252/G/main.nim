const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, P:seq[int]):
  var dp, dp2 = Seq[N + 1, N + 1: Option[mint]]
  proc calc(l, r:int):mint =
    if dp[l][r].isSome: return dp[l][r].get
    proc calc2(l, r:int):mint =
      if l == r: return 1
      if dp2[l][r].isSome: return dp2[l][r].get
      result = mint(0)
      for r2 in l + 1 .. r:
        if r2 == r or P[l] < P[r2]:
          result += calc(l, r2) * calc2(r2, r)
      dp2[l][r] = result.some
    result = calc2(l + 1, r)
    dp[l][r] = result.some
  echo calc(0, N)
  discard

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  solve(N, P)
else:
  discard

