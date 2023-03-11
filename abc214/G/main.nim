const
  DO_CHECK = true
  DEBUG = true
include lib/header/chaemon_header
import atcoder/dsu

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/math/combination

import macros

macro Pred(a:varargs[untyped]):auto =
  result = newStmtList()
  for i in 0 ..< a.len:
    let x = a[i]
    result.add quote do:
      var `x` = `x`.pred


solveProc solve(N:int, p:seq[int], q:seq[int]):
  Pred p, q
  # 直線状の場合
  # a: 切れている場合
  # b: 続いていて、点の選択が未
  # c: 続いていて、点の選択を完了
  # a[l][p]は長さl, 選んだ辺の本数がp
  var a, b, c = Seq[N + 1, N + 1: mint(0)]
  a[0][0] = 1
  b[0][1] = 1
  c[0][1] = 1
  for l in 1 .. N:
    for p in 0 .. N:
      a[l][p] += a[l - 1][p] # 辺を選ばない状態を継続
      a[l][p] += b[l - 1][p] + c[l - 1][p] # 辺の選択を終了
      if p > 0:
        b[l][p] += b[l - 1][p - 1] # 頂点を選ばないで継続
        c[l][p] += b[l - 1][p - 1] # 頂点を選んで継続
        c[l][p] += c[l - 1][p - 1] # 選んだ状態を継続
        b[l][p] += a[l - 1][p - 1] # 新たに開始
        c[l][p] += a[l - 1][p - 1] # 頂点を選んで開始
  proc get_circ(n:int):seq[mint] = # 長さはn + 1にする
    # 戻り値はresult[i]はi個選んだ場合の数
    if n == 1:
      return @[mint(1), mint(1)]
    result = Seq[n + 1: mint(0)]
    # 全部選ぶ場合
    result[n] += 2
    # 全部選ばない場合
    block:
      # 0番にかからない場合
      # N - 1 -> 0 -> 1は辺を選ばず、他はa
      for p in 0 .. n:
        result[p] += a[n - 2][p]
      # 0番にかかる場合その辺をTとする
      for l in 1 .. n - 1:
        # 開始位置の選択にl + 1通り, Tの頂点の選択にl + 1通り
        # 残りはn - l - 2個
        for p in 0 .. n:
          let p2 = p + l
          if p2 > n: continue
          var x = block:
            let r = n - l - 2
            if r < 0:
              if p == 0: mint(1)
              else: mint(0)
            else: a[r][p]
          result[p2] += x * (l + 1) * (l + 1)
  #for n in 1 .. N:
  #  debug get_circ(n)
  var d = initDSU(N)
  for i in N:
    d.merge(p[i], q[i])
  var dp = @[mint(1)]
  for g in d.groups:
    var
      c = get_circ(g.len)
      dp2 = Seq[dp.len + c.len - 1: mint(0)]
    for i in dp.len:
      for j in c.len:
        dp2[i + j] += dp[i] * c[j]
    dp = dp2.move
  var ans = mint(0)
  for t in 0 .. N:
    # t個をの辺を決めている。残りを決める
    var d = dp[t] * mint.fact(N - t)
    if t mod 2 == 1: d *= -1
    ans += d
  echo ans
  Naive:
    var ans = mint(0)
    var r = (1 .. N).toSeq
    while true:
      ok := true
      for i in N:
        if r[i] == p[i] or r[i] == q[i]: ok = false
      if ok: ++ans
      if not nextPermutation(r): break
    echo ans
  return

when not defined DO_TEST:
  var N = nextInt()
  var p = newSeqWith(N, nextInt())
  var q = newSeqWith(N, nextInt())
  solve(N, p, q)
else:
  for N in 1 .. 6:
    debug N
    var p = (1 .. N).toSeq
    while true:
      var q = (1 .. N).toSeq
      while true:
        #debug "test for: ", N, p, q
        test(N, p, q)
        if not nextPermutation(q): break
      if not nextPermutation(p): break
