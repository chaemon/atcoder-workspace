const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int):
  dp := Seq[M + 1, M + 1, M + 1: mint(0)]
  dp[M][M][M] = 1
  proc update(a, b, c, t: int):(int, int, int, bool) =
    var
      a2 = a
      b2 = b
      c2 = c
      ok = true
    if t < a: a2.min= t
    if a < t: b2.min= t
    if b < t: c2.min= t
    if c < t: ok = false
    return (a2, b2, c2, ok)
  for i in N:
    dp2 := Seq[M + 1, M + 1, M + 1: mint(0)]
    for a in 0..M:
      for b in 0..M:
        if a > b: continue
        for c in 0..M:
          if b > c: continue
          # a <= b <= c
          for t in 0 ..< M:
            var (a2, b2, c2, ok) = update(a, b, c, t)
            if not ok: continue
            dp2[a2][b2][c2] += dp[a][b][c]
    swap dp, dp2
  ans := mint(0)
  for a in 0..<M:
    for b in 0..<M:
      for c in 0..<M:
        ans += dp[a][b][c]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

