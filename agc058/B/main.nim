const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, P:seq[int]):
  var dp = Seq[N + 1: mint(0)] # 長さ
  dp[0] = 1
  for i in N:
    # P[i]を採用しない場合そのまま
    var dp2 = dp
    var cs = initDualCumulativeSum[mint](N + 1)
    # 採用する場合を足す
    # iから左方向
    #for x in 0 ..< i:
    #  if P[x .. i].max > P[i]: continue
    #  for y in x ..< i:
    #    # x .. yに採用
    #    dp2[y + 1] += dp[x]
    var x = i - 1
    while x >= 0:
      if P[x] > P[i]: break
      x.dec
    # x + 1 ..< iで有効
    for x in x + 1 ..< i:
      # x + 1 .. iに足す
      cs.add(x + 1 .. i, dp[x])
    # iから右方向
    #for y in i + 1 ..< N:
    #  if P[i .. y].max > P[i]: continue
    #  for x in i + 1 .. y:
    #    dp2[y + 1] += dp[x]
    var y = i + 1
    while y < N:
      if P[y] > P[i]: break
      y.inc
    # i + 1 ..< yで有効
    for x in i + 1 ..< y:
      # x .. yなる区間のy
      # dp[x]が決まっている
      cs.add(x + 1 .. y, dp[x])
    # iを含む
    #for x in 0 .. i:
    #  for y in i ..< N:
    #    if P[x .. y].max > P[i]: continue
    #    # x .. y
    #    dp2[y + 1] += dp[x]

    # x + 1 .. y - 1で有効
    for j in x + 1 .. i:
      # 長さjまで決定してる。dp[j]で始まる
      # 終了位置はi .. y - 1なら有効
      # つまり長さはi + 1 .. y
      cs.add(i + 1 .. y, dp[j])
    for i in 0 .. N: dp2[i] += cs[i]
    swap dp, dp2
  echo dp[N]
  Naive:
    var vis = initSet[seq[int]]()
    proc dfs(P:seq[int]) =
      vis.incl P
      for i in 0 ..< P.len - 1:
        var P = P
        let M = max(P[i], P[i + 1])
        P[i] = M
        P[i + 1] = M
        if P in vis: continue
        dfs(P)
    dfs(P)
    debug vis
    echo vis.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  solve(N, P)
else:
  #test(4, @[1, 0, 2, 3])
  test(3, @[2, 1, 0])
  let N = 3
  var a = (0 ..< N).toSeq
  while true:
    test(N, a)
    if not next_permutation(a): break

