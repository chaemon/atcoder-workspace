include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(N:int, M:int, K:int) =
  if N == 1:
    echo mint(K)^M;return
  elif M == 1:
    echo mint(K)^N;return
  var ans = mint(0)
  for Y in 1..K:
    var d = mint(K - Y + 1)^M
    if Y < K:
      d -= mint(K - Y)^M
    ans += d * mint(Y)^N
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K)
#}}}

