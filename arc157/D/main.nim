when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/dp/cumulative_sum_2D

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(H:int, W:int, S:seq[string]):
  # Yの累積和
  var
    cs = initCumulativeSum2D[int](H, W)
    y = 0
  for i in H:
    for j in W:
      if S[i][j] == 'Y':
        cs.add(i, j, 1)
  cs.build
  for i in H:
    y += S[i].count('Y')
  if y mod 2 == 1:
    echo 0;return
  let y2 = y div 2
  divisor := @(int, int)
  for d in 1 .. y2:
    if d * d > y2: break
    if y2 mod d == 0:
      let d2 = y2 div d
      divisor.add (d, d2)
      if d2 != d:
        divisor.add (d2, d)
  divisor.sort
  proc divide(v:seq[int], n:int):Option[seq[Slice[int]]] =
    a := @(Slice[int])
    # n個の区画に分ける, 戻り値はn - 1個のスライスで切れ目の位置
    var U = v.sum
    if U mod n != 0: return
    U = U div n
    # U個ずつに分ける
    i := 0
    for _ in n - 1:
      j := i
      s := 0
      while j < v.len and s < U:
        s += v[j]
        j.inc
      if s != U: return
      # v[i] + v[i + 1] + ... + v[j - 1] == U
      var k = j
      while k < v.len and v[k] == 0:
        k.inc
      a.add j - 1 .. k - 1
      i = k
    return a.some
  ans := mint(0)
  v := @int
  for i in H:
    v.add cs[i .. i, 0 ..< W]
  #debug divide(@[3, 1, 2, 0, 2, 1, 0], 3)
  for (h, w) in divisor:
    # 縦h個, 横w個の区画に分ける
    # 横方向に切る
    var pd = divide(v, h)
    if pd.isNone: continue
    var
      p = pd.get
      d = mint(1)
    for l in p:
      d *= l.b - l.a + 1
    # 縦方向に切る
    # pの分割に基づく
    var
      a = @(seq[Slice[int]])
      ok = true
    for i in h:
      var l, r:int
      if i == 0: l = 0
      else: l = p[i - 1].b + 1
      if i == h - 1: r = H
      else: r = p[i].a + 1
      # 行でl ..< rの範囲を切り取る
      v := @int
      for j in W:
        v.add cs[l ..< r, j .. j]
      # vをw個の区画にわける
      var pd = divide(v, w)
      if pd.isNone:
        ok = false
        break
      a.add pd.get
    if not ok: continue
    for y in a[0].len:
      var
        l = -int.inf
        r = int.inf
      for x in a.len:
        l.max=a[x][y].a
        r.min=a[x][y].b
      if l > r: ok = false;break
      d *= r - l + 1
    if not ok: continue
    ans += d
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

