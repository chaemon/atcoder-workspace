when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc solve() =
  let N, L, R = nextInt()
  var
    g = Seq[N + 1: int]
    a = Seq[Table[int, int]] # a[n]: 合計nで分割したときのxor一覧 (v, n - v)で分けるとxになる
    ct = Seq[int]
  for n in 0 .. N:
    # g[n]を決める
    if n < L:
      g[n] = 0
    else:
      var u = 0
      while u < ct.len and ct[u] > 0: u.inc
      g[n] = u


    var s = initTable[int, int]()
    # 合計nを決める
    for i in 0 .. n:
      let j = n - i
      if j < i: break
      # i <= j
      let q = g[i] xor g[j]
      if q in s: continue
      s[q] = i
    a.add s
    # n -> n + 1にする
    # 許される合計はn - R .. n - Lから
    # n - R + 1 .. n - L + 1へ
    if n - L + 1 >= 0: # n - L + 1を足す
      for x, v in a[n - L + 1]:
        if ct.len <= x:
          ct.setLen(x + 1)
        ct[x].inc
    if n - R >= 0: # n - Rを除く
      for x, v in a[n - R]:
        ct[x].dec
  proc move(n, t:int):tuple[l, m, r:int] = # n個の連のgrundy数をtにする
    doAssert g[n] > t
    for y in L .. R:
      let s = n - y
      if s < 0: continue
      # 合計sでtにできるか?
      if t in a[s]:
        let
          l = a[s][t]
          r = n - l - y
        return (l, y, r)
    doAssert false
  block:
    for n in 1 .. N:
      for t in 0 ..< g[n]:
        let (l, m, r) = move(n, t)
        doAssert l >= 0 and r >= 0
        doAssert l + m + r == n
        doAssert m in L .. R
        doAssert (g[l] xor g[r]) == t
  var
    turn = 0 # 0: 自分
    board = Seq[N: true]
  proc query(x, y:int) =
    for i in y:
      doAssert x + i in 0 ..< N
      doAssert board[x + i]
      board[x + i] = false
  if g[N] != 0:
    echo "First"
  else:
    echo "Second"
    turn = 1
  while true:
    if turn == 0:
      var
        i = 0
        v = Seq[Slice[int]]
      while i < N:
        while i < N and not board[i]: i.inc
        if i >= N: break
        var j = i
        while j < N and board[j]:j.inc
        v.add i ..< j
        i = j
      var
        l = Seq[int]
        xs = 0
      for i in v.len:
        l.add(v[i].len)
        xs.xor= g[v[i].len]
      doAssert xs != 0
      let t = fastLog2(xs)
      # tビット目が1のものを探す
      var u = -1
      for i,l in l:
        if (g[l] and (1 shl t)) != 0:
          u = i;break
      doAssert u >= 0
      # u番目のグランディ数をg[l[u]] からg[l[u]] xor xsにする
      let
        G = g[l[u]] xor xs
        (l0, m0, r0) = move(l[u], G)
        x = v[u].a + l0
        y = m0
      # 出力
      # v[u].a .. v[u].b
      echo x + 1, " ", m0
      query(x, y)
    else:
      var a, b = nextInt()
      if a == 0:
        doAssert b == 0
        break
      elif a == -1:
        doAssert b == -1
        break
      let (x, y) = (a - 1, b)
      query(x, y)
    turn = 1 - turn

when not defined(DO_TEST):
  solve()
else:
  discard

