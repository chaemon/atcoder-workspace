include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/dp/dual_cumulative_sum

proc solve(N:int, K:int) =
  var
    vis_dp = Seq(N + 1, N + 1, false)
    vis_sdp = Seq(N + 1, N + 1, false)
    dp = Seq(N + 1, N + 1, mint(0)) # sum, num
    sdp = Seq(N + 1, N + 1, mint(0)) # sum of dp[2(s - k)][n - k] for k = 0..s
  proc calc_sdp(s, n:int):mint
  proc calc_dp(s, n:int):mint =
    if s > N: return mint(0)
    if vis_dp[s][n]: return dp[s][n]
    vis_dp[s][n] = true
    if s == n: result = mint(1)
    else:
      result = calc_sdp(s, n)
    dp[s][n] = result
  proc calc_sdp(s, n:int):mint =
    if s < 0 or n < 0 or s > N: return mint(0)
    if vis_sdp[s][n]: return sdp[s][n]
    vis_sdp[s][n] = true
    result = calc_sdp(s - 1, n - 1) + calc_dp(s * 2, n)
    sdp[s][n] = result
  echo calc_dp(K, N)
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}
