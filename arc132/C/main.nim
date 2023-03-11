const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(n:int, d:int, a:seq[int]):
  # -d .. d
  var dp = Seq[2^(2 * d + 1): mint]
  block:
    b := 0
    for i in 0 ..< d: b[i] = 1
    dp[b] = 1
  for i in 0..<n:
    var dp2 = Seq[2^(2 * d + 1): mint]
    for b in 2^(2 * d + 1):
      if a[i] != -1:
        let t = a[i] - 1 - i + d
        if b[t] == 1: continue
        let b2 = b xor [t]
        if b2[0] == 0: continue
        dp2[b2 >> 1] += dp[b]
      else:
        for j in 2 * d + 1:
          if b[j] == 1: continue
          let b2 = b xor [j]
          if b2[0] == 0: continue
          dp2[b2 >> 1] += dp[b]
    swap dp, dp2
  block:
    b := 0
    for i in 0 ..< d:
      b[i] = 1
    echo dp[b]
  discard

when not DO_TEST:
  var n = nextInt()
  var d = nextInt()
  var a = newSeqWith(n, nextInt())
  solve(n, d, a)
else:
  discard

