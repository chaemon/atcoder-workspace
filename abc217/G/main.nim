const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/modint
type mint = modint998244353
import lib/math/combination

solveProc solve(N:int, M:int):
  let r = N mod M
  let q = N div M
  var dp = @[mint(1)]
  for t in (q+1).repeat(r) & (q).repeat(M - r):
    var dp2 = Seq[dp.len + t: mint(0)]
    for i in 0..t:
      for g in dp.len:
        # take i among g groups
        # rest: t - i
        dp2[g + t - i] += dp[g] * mint.C(g, i) * mint.C(t, i) * mint.fact(i)
    swap dp, dp2
  echo dp[1..^1].join("\n")
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

