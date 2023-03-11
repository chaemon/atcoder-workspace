const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:string, M:int, C:seq[int]):
  var dp = Seq[2, 2^10:(n:mint(0), s: mint(0))] # same digit, appeared
  for i in N.len:
    var dp2 = Seq[2, 2^10:(n:mint(0), s:mint(0))] # same digit, appeared
    let d = N[i].ord - '0'.ord
    # start
    if i == 0:
      for t in 1 ..< d:
        dp2[0][1 shl t].n += 1
        dp2[0][1 shl t].s += t
      dp2[1][1 shl d].n += 1
      dp2[1][1 shl d].s += d
    else:
      for t in 1 .. 9:
        dp2[0][1 shl t].n += 1
        dp2[0][1 shl t].s += t
    # prev
    for b in 2^10:
      for t in 0 .. 9:
        dp2[0][b or [t]].n += dp[0][b].n
        dp2[0][b or [t]].s += dp[0][b].s * 10 + dp[0][b].n * t
      for t in 0 ..< d:
        dp2[0][b or [t]].n += dp[1][b].n
        dp2[0][b or [t]].s += dp[1][b].s * 10 + dp[1][b].n * t
      dp2[1][b or [d]].n += dp[1][b].n
      dp2[1][b or [d]].s += dp[1][b].s * 10 + dp[1][b].n * d
    swap dp, dp2
  var mask = 0
  for i in M:
    mask.or= 1 shl C[i]
  ans := mint(0)
  for b in 2^10:
    if (mask and b) == mask:
      ans += dp[0][b].s + dp[1][b].s
  echo ans
  discard

when not DO_TEST:
  var N = nextString()
  var M = nextInt()
  var C = newSeqWith(M, nextInt())
  solve(N, M, C)
else:
  discard
