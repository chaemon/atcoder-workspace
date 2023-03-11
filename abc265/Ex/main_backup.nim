const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type F = tuple[n, d:int]
proc `<`(l, r:F):bool =
  l.n * r.d < r.n * l.d

solveProc solve(H:int, W:int):
  var
    dp = Seq[W, W: F] # 右向き, 左向き
    vis = Seq[W, W: false]
  proc calc_val(l, r:F):F =
    var d = 1
    while true:
      # l.n / l.d = x / d
      var l0, r0:int
      if l.d == 0:
        l0 = -int.inf
      else:
        l0 = ceilDiv(l.n * d, l.d)
        if (l.n * d) mod l.d == 0: l0.inc
      if r.d == 0:
        r0 = int.inf
      else:
        r0 = floorDiv(r.n * d, r.d)
        if (r.n * d) mod r.d == 0: r0.dec
      if l0 <= r0:
        if r0 < 0:
          return (r0, d)
        elif 0 < l0:
          return (l0, d)
        else:
          return (0, 1)
      d *= 2
  proc calc(i, j:int):F =
    if vis[i][j]: return dp[i][j]
    vis[i][j] = true
    var
      l:F = (-1, 0)
      r:F = (1, 0)
    for i2 in i + 1 ..< W:
      if i2 == j: break
      l.max= calc(i2, j)
    for j2 in countdown(j - 1, 0):
      if j2 == i: break
      r.min= calc(i, j2)
    debug i, j, l, r
    result = calc_val(l, r)
    debug i, j, l, r, result
  echo calc(0, 2)
  #var
  #  S = 0
  #  U = 0
  #for i in W:
  #  for j in W:
  #    if i == j: continue
  #    let u = calc(i, j)
  #    S.inc
  #    if u.n == 0: U.inc
  #debug S, U
  #echo mint(S)^H - mint(U)^H
  #doAssert gs.len <= 4
  #block:
  #  var dp = Seq[4:mint(0)]
  #  dp[0] = 1
  #  for _ in H:
  #    var dp2 = Seq[4:mint(0)]
  #    for i in dp.len:
  #      for j in gs.len:
  #        let k = i xor j
  #        dp2[k] += dp[i] * gs[j]
  #    swap dp, dp2
  #  echo dp.sum - dp[0]
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
else:
  discard

