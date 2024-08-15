when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/dsu

const MAX = 2 * 10^5 + 5

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  var
    ct = 0 # 現在の個数
    ys = Seq[MAX: seq[int]]
    ls = Seq[MAX: seq[int]]
    a = Seq[MAX: seq[tuple[l, r, i:int]]]
    base = ct
  ct.inc
  for i in N:
    ys[X[i]].add Y[i]
  for x in MAX:
    ys[x].sort
    # ys[x]をセグメントで切る
    for i in 0 .. ys[x].len:
      var l, r:int
      if i == 0: l = -1
      else: l = ys[x][i - 1] + 1
      if i == ys[x].len: r = MAX
      else: r = ys[x][i] - 1
      if l > r: continue
      # l .. rのセグメントを追加
      ls[x].add l
      a[x].add (l, r, ct)
      ct.inc
  proc find_id(x, y:int):int =
    # a[x]においてyが含まれる区間のidを探す。なければ-1
    let i = ls[x].upperBound(y) - 1
    doAssert i >= 0 and ls[x][i] <= y
    let (l, r, di) = a[x][i]
    if y in l .. r: return di
    else: return -1

  var d = initDSU(ct)
  for x in MAX:
    for (l, r, di) in a[x]:
      if l == -1 or r == MAX:
        d.merge(di, base)
    # 下をつなげる
    if x == 0:
      for (l, r, di) in a[x]:
        d.merge(di, base)
    else:
      for (l, r, di) in a[x]:
        if (i := find_id(x - 1, l)) != -1:
          d.merge(di, i)
        if (i := find_id(x - 1, r)) != -1:
          d.merge(di, i)
    # 上をつなげる
    if x == MAX - 1:
      for (l, r, di) in a[x]:
        d.merge(di, base)
    else:
      for (l, r, di) in a[x]:
        if (i := find_id(x + 1, l)) != -1:
          d.merge(di, i)
        if (i := find_id(x + 1, r)) != -1:
          d.merge(di, i)
  var ans = 0
  for x in MAX:
    for (l, r, di) in a[x]:
      if not d.same(di, base): ans += r - l + 1
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

