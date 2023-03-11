include atcoder/extra/header/chaemon_header

import atcoder/modint
import atcoder/extra/dp/cumulative_sum
const MOD = 998244353
type mint = modint998244353

proc solve(H:int, W:int, K:int, h:seq[int], w:seq[int], c:seq[string]) =
  var
    cc = Seq(H, W, '?')
    rows = Seq(H, initCumulativeSum[int16](W))
    cols = Seq(W, initCumulativeSum[int16](H))
    pow3 = newSeq[mint](5050)
  for i in 0..<H:
    for j in 0..<W:
      rows[i][j] = 1
      cols[j][i] = 1
  pow3[0] = 1
  for i in 1..<pow3.len:
    pow3[i] = pow3[i - 1] * 3
  for i in 0..<K:
    cc[h[i]][w[i]] = c[i][0]
    rows[h[i]][w[i]] = 0
    cols[w[i]][h[i]] = 0
  var dp = Seq(H, W, mint(0))
  dp[0][0] = 1
  for i in 0..<H:
    for j in 0..<W:
      let i2 = i + 1
      let j2 = j + 1
      if cc[i][j] == 'R':
        if j2 < W: dp[i][j2] += dp[i][j] * pow3[cols[j2][0..<i]]
      elif cc[i][j] == 'D':
        if i2 < H: dp[i2][j] += dp[i][j] * pow3[rows[i2][0..<j]]
      elif cc[i][j] == 'X':
        if j2 < W: dp[i][j2] += dp[i][j] * pow3[cols[j2][0..<i]]
        if i2 < H: dp[i + 1][j] += dp[i][j] * pow3[rows[i2][0..<j]]
      else:
        if j2 < W: dp[i][j2] += dp[i][j] * pow3[cols[j2][0..<i]] * 2
        if i2 < H: dp[i2][j] += dp[i][j] * pow3[rows[i2][0..<j]] * 2
  if cc[H - 1][W - 1] == '?':
    dp[H - 1][W - 1] *= 3
  echo dp[H - 1][W - 1]
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  var h = newSeqWith(K, 0)
  var w = newSeqWith(K, 0)
  var c = newSeqWith(K, "")
  for i in 0..<K:
    h[i] = nextInt() - 1
    w[i] = nextInt() - 1
    c[i] = nextString()
  solve(H, W, K, h, w, c)
#}}}
