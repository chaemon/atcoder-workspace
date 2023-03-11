include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

type St = object
  t, r, d, rd:mint

proc solve() =
  let H, W = nextInt()
  let S = Seq(H, nextString())
  var dp = Seq(H, W, St)
  var vis = Seq(H, W, false)
  dp[0][0].t = mint(1)
  for i in 0..<H:
    for j in 0..<W:
      dp[i][j].t += dp[i][j].r + dp[i][j].d + dp[i][j].rd
      if i + 1 < H and S[i + 1][j] != '#':
        dp[i + 1][j].d += dp[i][j].d + dp[i][j].t
      if j + 1 < W and S[i][j + 1] != '#':
        dp[i][j + 1].r += dp[i][j].r + dp[i][j].t
      if i + 1 < H and j + 1 < W and S[i + 1][j + 1] != '#':
        dp[i + 1][j + 1].rd += dp[i][j].rd + dp[i][j].t
  echo dp[H - 1][W - 1].t
  return

# input part {{{
block:
  solve()
#}}}
