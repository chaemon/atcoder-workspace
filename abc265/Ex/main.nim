const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination
import lib/math/ntt
import lib/math/formal_power_series
import lib/math/composition

var x = initVar[mint]()

# calc g(f(x))
proc calc_composition(f, g:FormalPowerSeries[mint]):FormalPowerSeries[mint] =
  var
    now = newSeq[FormalPowerSeries[mint]](g.len)
    f = f
  for i in g.len:
    now[i] = initFormalPowerSeries[mint](@[g[i]])
  while now.len > 1:
    var
      v = now.len
      now2 = newSeq[FormalPowerSeries[mint]]((v + 1) div 2)
    for i in 0 ..< v >> 2:
      if i == v - 1: now2[i div 2] = now[i]
      else:
        let i2 = i div 2
        now2[i2] = now[i]
        now2[i2] += now[i + 1] * f
    now = now2.move
    f *= f
  return now[0]

solveProc solve(H:int, W:int):
  # 先手と後手の背中合わせで動かせる個数が同数のものを数える
  var dp_nim = Seq[H + 1, 32: mint(0)]
  dp_nim[0][0] = 1
  for h in 0..<H:
    #debug h, dp_nim[h]
    for x in 0 ..< 32:
      for d in 0 .. W - 2:
        let c = W - 1 - d
        dp_nim[h + 1][x xor d] += dp_nim[h][x] * c
  # 先手の方が背中合わせで動かせる数が多い
  # または同数かつNim和が0でない
  # - (W - 2) .. (W - 2)
  let B = W - 2
  var f = initFormalPowerSeries[mint](B * 2 + 1)
  for i in W:
    for j in i + 1 ..< W:
      let u = i - (W - 1 - j)
      f[u + B] += 1
  # g(x + 1/x) = f(x)となるgを求める
  var g = initFormalPowerSeries[mint](W - 1)
  block:
    var
      f = f
      t = Seq[FormalPowerSeries[mint]]
    t.add @[mint(1)]
    for i in 1 .. W - 2:
      t.add t[^1] * (1 + x^2) 
    for i in 0 .. W - 2:
      # i番目の場合真ん中はx^iなのでこれをx^Bにしたい
      t[i] *= x^(B - i)
    # t[i] = (1 + x^2)^iになっている
    for i in countdown(W - 2, 0):
      c := f[i + B]
      g[i] = c
      f -= c * t[i]
  # Nim和 = 0かつ背中合わせ和が0 : X
  # 背中合わせ和が0 : Y
  # 全体: U
  # 答え: (U - Y) / 2 + Y - X = U / 2 + Y / 2 - X
  var S, X, Y = mint(0)
  block:
    let s = mint((W * (W - 1)) div 2)
    var P = initFormalPowerSeries[mint](H + 1)
    for h in 0 .. H:
      let T = s^(H - h)
      doAssert dp_nim[H - h].sum == T
      P[h] = mint.C(H, h) * (T / 2 - dp_nim[H - h][0])
    #let d = (g.len - 1) * (P.len - 1) + 1
    # P(g(x))を求める
    #var Q = composition(g, P, d)
    var Q = calc_composition(g, P)
    for i in Q.len:
      if i mod 2 != 0: continue
      S += mint.C(i, i div 2) * Q[i]
  echo (mint(W * (W - 1))^H) / 2 + S
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
else:
  discard

