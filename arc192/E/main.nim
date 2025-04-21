when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(W:int, H:int, L:int, R:int, D:int, U:int):
  proc F(b, k:int):mint =
    # a = 0 .. kでC(a + b, b)の和
    return mint.C(b + k + 1, b + 1)
  proc F1(b, k:int):mint =
    # a = 0 -> kでa * C(a + b, b)の和
    return (b + 1) * F(b + 1, k - 1)
  proc half(W, H: int):mint =
    # a in 0 .. W, b in 0 .. Hについて
    #result = 0
    #for b in 0 .. H:
    #  #result += F(b, W)
    #  result += C(b + W + 1, W)
    if W < 0 or H < 0: return 0
    return (H + 2) * mint.C(H + W + 2, W) * mint.inv(W + 1) - 1
  proc all(W, H:int):mint =
    # 0 .. W, 0 .. Hの場合の全体
    result = 0
    for b in 0 .. H:
      # aについて足す
      result += F(b, W) * (W + 1) * (H - b + 1)
      result -= F1(b, W) * (H - b + 1)
  proc through_inside_outside(W, H, L, R, D, U:int):mint =
    # W x Hの京都でL .. R, D .. Uの長方形を通って外に出る場合の数
    # (x = L .. R, U)から上に行く方法
    # (R, y = D .. U)から右に行く方法
    result = 0
    for x in L .. R:
      result += half(x, U) * half(W - x, H - 1 - U)
    for y in D .. U:
      result += half(R, y) * half(W - 1 - R, H - y)
  proc inside_outside(W, H, L, R, D, U:int):mint =
    # 長方形の中から外に行く
    # L = 0, D = 0にずらす
    return through_inside_outside(W - L, H - D, 0, R - L, 0, U - D)
  proc outside_inside_outside(W, H, L, R, D, U:int):mint =
    # 外側から内側を通って外側へ
    return through_inside_outside(W, H, L, R, D, U) - inside_outside(W, H, L, R, D, U)
  var
    ans = all(W, H)
    p = outside_inside_outside(W, H, L, R, D, U) # 外内外
    q = inside_outside(W, H, L, R, D, U) # 内外
    r = inside_outside(W, H, W - R, W - L, H - U, H - D) # 外内 # inside_outsideから上下左右を逆にする
    s = all(R - L, U - D)
  ans -= p + q + r + s
  echo ans
  doAssert false
  when DO_TEST:
    for b in 0 .. 20:
      for k in 0 .. 20:
        var s, t = mint(0)
        for a in 0 .. k:
          s += mint.C(a + b, b)
          t += mint.C(a + b, b) * a
        #debug t, F1(b, k)
        doAssert F(b, k) == s
        doAssert F1(b, k) == t
    for W in 0 .. 20:
      for H in 0 .. 20:
        var s, t = mint(0)
        for a in 0 .. W:
          for b in 0 .. H:
            s += mint.C(a + b, b)
            for a1 in a .. W:
              for b1 in b .. H:
                t += mint.C(a1 - a + b1 - b, b1 - b)
        doAssert s == half(W, H)
        doAssert t == all(W, H)
    for W in 0 .. 10:
      for H in 0 .. 10:
        for L in 0 .. W:
          for R in L .. W:
            for D in 0 .. H:
              for U in D .. H:
                var s = mint(0)
                for x in L .. R:
                  for y in D .. U:
                    for x1 in x .. W:
                      for y1 in y .. H:
                        if x1 in L .. R and y1 in D .. U: continue
                        let
                          a = x1 - x
                          b = y1 - y
                        #debug x, y, x1, y1, a, b, mint.C(a + b, b)
                        s += mint.C(a + b, b)
                let s1 = inside_outside(W, H, L, R, D, U)
                #debug W, H, L, R, D, U, s, s1
                doAssert s == inside_outside(W, H, L, R, D, U)




  discard

when not defined(DO_TEST):
  var W = nextInt()
  var H = nextInt()
  var L = nextInt()
  var R = nextInt()
  var D = nextInt()
  var U = nextInt()
  solve(W, H, L, R, D, U)
else:
  discard

