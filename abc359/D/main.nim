when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, K:int, S:string):
  var
    dp = Seq[2^K: mint(0)]
    palin = Seq[2^K: false]
  for b in 2^K:
    is_palin := true
    for i in K:
      let j = K - 1 - i
      if i > j: break
      if b[i] != b[j]: is_palin = false
    palin[b] = is_palin
  dp[0] = 1
  for i in N:
    var
      dp2 = Seq[2^K: mint(0)]
    #debug i, dp
    for b in 2^K:
      var b2 = b shl 1
      if S[i] == '?' or S[i] == 'A':
        var b2 = b2
        b2[K] = 0
        if i < K - 1 or not palin[b2]:
          dp2[b2] += dp[b]
      if S[i] == '?' or S[i] == 'B':
        var b2 = b2
        b2[0] = 1
        b2[K] = 0
        if i < K - 1 or not palin[b2]:
          dp2[b2] += dp[b]
    dp = dp2.move
  echo dp.sum
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S = nextString()
  solve(N, K, S)
else:
  discard

