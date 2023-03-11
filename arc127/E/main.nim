const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(A:int, B:int, X:seq[int]):
  var
    q = Seq[int]
    one_ct = 0
    v = Seq[A:0]
  for a in X:
    if a == 1:
      q.add one_ct
      one_ct.inc
    elif a == 2:
      v[q.pop] = 1
    else:
      assert false
  var dp = Seq[A: mint(0)]
  dp[0] = 1
  for i,a in v:
    var dp2 = Seq[A:mint(0)]
    if a == 0:
      dp2[0] += dp[0]
      for i in 0..<A-1:
        dp2[i] += dp[i + 1]
    else:
      dp2[0] = dp[0]
      for i in 1..<A:
        dp2[i] = dp2[i - 1] + dp[i]
    swap dp, dp2
  echo dp[0]
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var X = newSeqWith(A+B, nextInt())
  solve(A, B, X)
else:
  discard

