const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 400

var ct = Array[-1 .. B, -1 .. B: 0] # ct[i][j]: i .. jを含む区間の個数
var dp, dp2 = Array[-1 .. B + 1, B + 1, 2 : mint(0)] # dp[t][c][p]: 最後に選んだのがt, 区間の個数: c, 選んだ個数の偶奇: p

# Failed to predict input format
solveProc solve(N, M:int, L, R: seq[int]):
  for i in M:
    for l in 0 .. L[i]:
      for r in R[i] ..< N:
        ct[l][r].inc
  dp[-1][0][0] = 1
  for i in N + 1:
    dp2 = dp
    # iを最後に入れる
    for j in -1 ..< i: # 直前がj
      for c in 0 .. M:
        for p in 0 .. 1:
          let c2 = c + ct[j + 1][i - 1]
          if c2 notin 0 .. M: continue
          dp2[i][c2][1 - p] += dp[j][c][p]
    swap dp, dp2
  var
    ans = mint(0)
    p0 = mint(1) / M
  for c in 1 ..< M:
    for p in 0 .. 1:
      let p2 = 1 - p
      if p2 == 0:
        ans += dp[N][c][p] / (1 - p0 * c)
      else:
        ans -= dp[N][c][p] / (1 - p0 * c)
      # debug c, p, dp[N][c][p]
  for p in 0 .. 1:
    let p2 = 1 - p
    if p2 == 0:
      ans += dp[N][0][p]
    else:
      ans -= dp[N][0][p]
  echo -ans


when not DO_TEST:
  let N, M = nextInt()
  var L, R = Seq[M: int]
  for i in M:
    L[i] = nextInt() - 1
    R[i] = nextInt() - 1
  solve(N, M, L, R)
else:
  discard

