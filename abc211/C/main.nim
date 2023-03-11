const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

var a = "chokudai"

solveProc solve(S:string):
  var dp = Seq[a.len + 1: mint(0)]
  dp[0] = 1
  for i in S.len:
    var dp2 = dp
    for j in 0..<a.len:
      if S[i] == a[j]:
        dp2[j + 1] += dp[j]
    swap dp, dp2
  echo dp[^1]
  return

# input part {{{
when not DO_TEST:
  var S = nextString()
  solve(S)
#}}}

