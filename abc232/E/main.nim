const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(H:int, W:int, K:int, x:seq[int], y:seq[int]):
  var dp = Seq[2, 2: mint(0)]
  var x0, y0:int
  if x[0] == x[1]:
    x0 = 0
  else:
    x0 = 1
  if y[0] == y[1]:
    y0 = 0
  else:
    y0 = 1
  dp[x0][y0] = 1
  for k in K:
    var dp2 = Seq[2, 2: mint(0)]
    # 残留
    if W >= 2:
      dp2[0][1] += dp[0][1] * (W - 2)
    if H >= 2:
      dp2[1][0] += dp[1][0] * (H - 2)
    dp2[1][1] += (H - 2 + W - 2) * dp[1][1]
    # 変更
    dp2[0][0] += dp[0][1] + dp[1][0]
    dp2[1][0] += dp[0][0] * (H - 1) + dp[1][1]
    dp2[0][1] += dp[0][0] * (W - 1) + dp[1][1]
    dp2[1][1] += dp[0][1] * (H - 1) + dp[1][0] * (W - 1)
    swap(dp, dp2)
  echo dp[0][0]
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  var x = newSeqWith(2, 0)
  var y = newSeqWith(2, 0)
  for i in 0..<2:
    x[i] = nextInt() - 1
    y[i] = nextInt() - 1
  solve(H, W, K, x, y)
else:
  discard

