include atcoder/extra/header/chaemon_header

import atcoder/modint
import atcoder/extra/math/combination

const MOD = 1000000007
type mint = modint1000000007

let f2 = mint(1) / mint(2)

proc cycle(n:int):auto =
  if n <= 2: return mint(1)
  else: return mint.fact(n - 1) * f2

proc path(n:int):auto =
  if n <= 2: return mint(1)
  else: return mint.fact(n) * f2

proc solve(N:int, M:int, L:int) =
  if L == 1:
    if M > 0: echo 0
    else: echo 1
    return
  var dp = Seq(N + 1, M + 1, 2, mint(0))
  dp[0][0][0] = mint(1)
  for n in 0..<N:
    let d = N - n
    for m in 0..M:
      # isolated
      dp[n + 1][m][0] += dp[n][m][0]
      dp[n + 1][m][1] += dp[n][m][1]
      for t in 2..L:
        # add t
        if t > d: break
        if m + t <= M:
          if t < L:
            dp[n + t][m + t][0] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][0]
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][1]
          else:
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][0]
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][1]
        # path
        if m + t - 1 <= M:
          if t < L:
            dp[n + t][m + t - 1][0] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][0]
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][1]
          else:
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][0]
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][1]
  echo dp[N][M][1]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  solve(N, M, L)
#}}}
