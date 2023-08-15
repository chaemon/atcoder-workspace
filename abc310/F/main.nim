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
solveProc solve(N:int, A:seq[int]):
  var dp = Seq[2^11: mint(0)]
  dp[1] = 1
  for i in N:
    let p = 1 / mint(A[i])
    var dp2 = Seq[2^11: mint(0)]
    for b in 0 ..< 2^11:
      if dp[b] == 0: continue
      for d in 1 .. 10:
        if d > A[i]: break
        var b2 = (b or (b shl d)) and ((1 shl 11) - 1)
        dp2[b2] += dp[b] * p
      # 11〜A[i]
      if 11 <= A[i]:
        dp2[b] += dp[b] * (A[i] - 11 + 1) * p
    dp = dp2.move
  var ans = mint(0)
  for b in 0 ..< 2^11:
    if b[10] == 1:
      ans += dp[b]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

