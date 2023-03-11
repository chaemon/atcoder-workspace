include atcoder/extra/header/chaemon_header

import atcoder/modint

const MOD = 1000000007
type mint = modint1000000007

const
  B = 320
  D = 10^5 + 10
var dp = Array(B, D, mint)

proc solve(N:int, M:int) =
  for i in 0..<dp[0].len: dp[0][0] = mint(0)
  dp[0][1] = mint(1)
  var s = 0
  for i in 1..<B:
    s += i
    for j in 0..<D:
      dp[i][j] = dp[i - 1][j]
      if j >= s: dp[i][j] += dp[i][j - s]
  var ans = mint(0)
  var Amin = 0
  while true:
    let M2 = M - Amin * N
    if M2 < 0: break
    for i in 0..<B:
      for j in 0..<B:
        if i + j > N - 1: continue
    

    Amin.inc
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}
