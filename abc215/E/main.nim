const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/other/bitutils

solveProc solve(N:int, S:string):
  var dp = Seq[2^10, 10: mint(0)]
  for i in N:
    var dp2 = dp
    let u = S[i] - 'A'
    dp2[2^u][u] += 1
    for b in 2^10:
      for j in 10:
        if b[j] == 0: continue
        if j == u:
          dp2[b][u] += dp[b][j]
        elif b[u] == 0:
          dp2[b xor [u]][u] += dp[b][j]
    dp = dp2.move
  ans := mint(0)
  for b in 2^10:
    for j in 10:
      ans += dp[b][j]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard
