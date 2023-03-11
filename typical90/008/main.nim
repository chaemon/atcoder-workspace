const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, S:string):
  let T = "atcoder"
  var dp = Seq[N: mint(0)]
  for j in N:
    if S[j] == T[0]:
      dp[j] = 1
  for i in 1 ..< T.len:
    var
      s = mint(0)
      dp2 = Seq[N: mint(0)]
    for j in N:
      if T[i] == S[j]:
        dp2[j] = s
      s += dp[j]
    swap dp, dp2
  echo dp.sum
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

