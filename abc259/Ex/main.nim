const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
import lib/math/combination

solveProc solve(N:int, a:seq[seq[int]]):
  var t = Seq[N * N: seq[(int, int)]]
  for i in N:
    for j in N:
      t[a[i][j]].add (i, j)
  ans := mint(0)
  proc solve(t:seq[(int, int)]) =
    for i in t.len:
      let (x, y) = t[i]
      for j in i ..< t.len:
        let (x1, y1) = t[j]
        if x <= x1 and y <= y1:
          ans += mint.C(y1 - y + x1 - x, x1 - x)
  proc solve(c:int) =
    var dp = Seq[N, N: mint(0)]
    for i in N:
      for j in N:
        if i - 1 >= 0:
          dp[i][j] += dp[i - 1][j]
        if j - 1 >= 0:
          dp[i][j] += dp[i][j - 1]
        if a[i][j] == c:
          dp[i][j] += 1
          ans += dp[i][j]
  for c in t.len:
    if t[c].len == 0: continue
    if t[c].len >= N:
      solve(c)
    else:
      solve(t[c])
  echo ans

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, newSeqWith(N, nextInt() - 1))
  solve(N, a)
else:
  discard

