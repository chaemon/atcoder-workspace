const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(K:int):
  if K mod 9 != 0: echo 0;return
  var dp = Seq[K + 1: mint(0)]
  dp[0] = 1
  for i in 1 .. K:
    for d in 1 .. 9:
      let j = i - d
      if j >= 0:
        dp[i] += dp[j]
  echo dp[K]
  return

# input part {{{
when not DO_TEST:
  var K = nextInt()
  solve(K)
#}}}

