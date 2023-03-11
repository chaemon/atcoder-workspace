const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 3000

solveProc solve(N:int, a:seq[int], b:seq[int]):
  var dp = Seq[B + 1:mint(0)]
  dp[0] = 1
  for i in 0..<N:
    var dp2 = Seq[B + 1: mint(0)]
    var s = mint(0)
    for t in 0..B:
      s += dp[t]
      if t in a[i]..b[i]: dp2[t] = s
    swap dp, dp2
  echo dp.sum
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  solve(N, a, b)
else:
  discard

