when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/segtree

type S = tuple[n, s:int] # 個数と和

proc op(a, b:S):S =
  (a.n + b.n, a.s + b.s)
proc e():S = (0, 0)

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var
    X, D = Seq[N: int]
  for i in N:
    X[i] = nextInt()
    var d = nextString()
    if d[0] == 'R':
      D[i] = 1
    else:
      D[i] = -1
  var qu: seq[seq[int]]
  for _ in Q:
    let t = nextInt()
    if t == 1:
      var
        x = nextInt()
        D = nextString()
        d:int
      if D[0] == 'R':
        d = 1
      else:
        d = -1
      qu.add @[1, x, d]
    elif t == 2:
      var l, r = nextInt()
      l.dec
      qu.add @[2, l, r]
    else:
      doAssert false
  # X[0]の向きが-1のときは全部-1倍
  if D[0] == -1:
    for i in N:
      X[i] *= -1
      D[i] *= -1
    for i in Q:
      if qu[i][0] == 1:
        qu[i][1] *= -1
        qu[i][2] *= -1
  # X[0]の座標を0に補正
  let X0 = X[0]
  for i in N:
    X[i] -= X0
  for i in Q:
    if qu[i][0] == 1:
      qu[i][1] -= X0
  var xp, xm: seq[int]
  for i in N:
    if D[i] == 1:
      if X[i] <= 0:
        xp.add -X[i]
    elif D[i] == -1:
      if 0 < X[i]:
        xm.add X[i]
    else:
      doAssert false
  for i in Q:
    if qu[i][0] == 1:
      let
        x = qu[i][1]
        d = qu[i][2]
      if d == 1:
        if x <= 0:
          xp.add -x
      elif d == -1:
        if 0 < x:
          xm.add x
      else:
        doAssert false
  xp.sort
  xp = xp.deduplicate(isSorted = true)
  xm.sort
  xm = xm.deduplicate(isSorted = true)

  # y = x + dとy = -x + d'の交点はx = (d' - d) / 2, y = (d + d') / 2
  var
    stp = initSegTree[S](xp.len, op, e)
    stm = initSegTree[S](xm.len, op, e)
  for i in N:
    if D[i] == 1:
      if X[i] <= 0:
        let X = -X[i]
        let xi = xp.lower_bound(X)
        doAssert xp[xi] == X
        stp[xi] = (1, X)
    else:
      if X[i] > 0:
        let X = X[i]
        let xi = xm.lower_bound(X)
        doAssert xm[xi] == X
        stm[xi] = (1, X)
  # (0, 0), (1, 0), (1, 1), (2, 1), (2, 2), ...
  proc calc(i:int):int =
    # i番目の衝突までの和を計算する。0 .. i
    var
      l, r = i div 2
      s = 0
    if i mod 2 == 1:
      l.inc
    var q:int
    proc f(s:S):bool = s.n < q
    q = 1
    let p0i = stp.maxRight(0, f)
    q = l + 1
    let pli = stp.maxRight(0, f)
    #q = 1
    #let m0i = stm.maxRight(0, f)
    q = r + 1
    let mri = stm.maxRight(0, f) # 合計r
    # 最後の衝突は(l, r)
    s += stp[0 .. pli].s * 2
    s += stm[0 .. mri].s * 2
    if i mod 2 == 1: # 偶数個
      # stpは0, 1, 1, 2, 2, ..., l - 1, l - 1, l
      s -= stp[p0i].s
      s -= stp[pli].s
      # stmは0, 0, 1, 1, ..., r - 1, r - 1, r, r
    else:
      # stpは0, 1, 1, 2, 2, ..., l, l
      s -= stp[p0i].s
      # stmは0, 0, 1, 1, ..., r - 1, r - 1, r
      s -= stm[mri].s
    return s div 2
  proc calc_pos(i:int):int =
    var
      l, r = i div 2
      s = 0
    if i mod 2 == 1:
      l.inc
    var q:int
    proc f(s:S):bool = s.n < q
    q = l + 1
    let pli = stp.maxRight(0, f)
    q = r + 1
    let mri = stm.maxRight(0, f) # 合計r

    if pli == stp.len or mri == stm.len: doAssert false
    return (stp[pli].s + stm[mri].s) div 2
  for i in Q:
    let t = qu[i][0]
    if t == 1:
      var
        X = qu[i][1]
        d = qu[i][2]
      if d == 1:
        if X <= 0:
          X *= -1
          let xi = xp.lower_bound(X)
          doAssert xp[xi] == X
          stp[xi] = (1, X)
      elif d == -1:
        if X > 0:
          let xi = xm.lower_bound(X)
          doAssert xm[xi] == X
          stm[xi] = (1, X)
    elif t == 2:
      let
        l = qu[i][1]
        r = qu[i][2]
      var
        ans = 0
      ans += calc(r - 1)
      if l > 0:
        ans -= calc(l - 1)
      echo ans
    else:
      doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

