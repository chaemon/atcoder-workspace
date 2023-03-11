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

# Failed to predict input format

when not DO_TEST:
  solveProc solve(H, W, N:int, c:seq[string]):
    var dp = Seq[2^H:mint]
    dp[2^H - 1] = 1
    for t in N:
      block:
        var dp2 = Seq[2^W:mint(0)]
        for b in 2^H:
          if dp[b] == 0: continue
          var b2 = Seq[10:int]
          for i in H:
            if b[i] == 0: continue
            for j in W:
              let d = c[i][j].ord - '0'.ord
              b2[d][j] = 1
          for d in 1..9:
            if b2[d] == 0: continue
            dp2[b2[d]] += dp[b]
        swap dp, dp2
      block:
        var dp2 = Seq[2^H:mint(0)]
        for b in 2^W:
          if dp[b] == 0: continue
          var b2 = Seq[10:int]
          for j in W:
            if b[j] == 0: continue
            for i in H:
              let d = c[i][j].ord - '0'.ord
              b2[d][i] = 1
          for d in 1..9:
            if b2[d] == 0: continue
            dp2[b2[d]] += dp[b]
        swap dp, dp2
    echo dp.sum
    discard

  var H, W, N = nextInt()
  var c = Seq[H: nextString()]
  solve(H, W, N, c)
else:
  discard


