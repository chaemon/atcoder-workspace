const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

var vsolve, vsolve_naive: seq[seq[int]]

proc test(a:seq[int], N:int):bool =
  var dp = newSeq[int](N + 1)
  dp[0] = 1
  for a in a:
    var dp2 = dp
    for i in 0 .. N:
      if i + a <= N:
        dp2[i + a] += dp[i]
    swap dp, dp2
    for i in 1 .. N:
      if dp[i] >= 3:
        return false
  for i in 1 .. N:
    if dp[i] == 0:
      return false
  return true


solveProc solve(N:int):
  if N == 1:
    echo 1
    return
  elif N == 2:
    echo 1
    return
  let D = N * 2 + 10
  var
    dp = newSeqWith(N + 1, initDualCumulativeSum[mint](D))
    dp0 = Seq[N + 2, N * 2 + 1: mint(0)]
    dp0v = Seq[N + 2, N * 2 + 1: seq[seq[int]]]
    ans = mint(0)
  # 2べきだけ選ぶ場合は1通りだけのはず
  ans.inc
  block:
    var
      v = 1
      a = @[1]
    while true:
      if v > N: break
      debug v
      # v + 1 ..< v * 2の中のpを選ぶ
      # [v * 2, v * 2 + p)が追加される
      for p in v + 1 .. min(N, v * 2 - 1):
        if v * 2 > N:
          vsolve.add a & p
          ans.inc
        else:
          var r = min(v * 2 + p, N * 2)
          dp0[v * 2][r].inc
          dp0v[v * 2][r].add(a & p)
      v *= 2
      a.add v
  debug "initial ans: ", ans
  # 
  # I = [a, b)の区間が与えられるa - 1が2通りで表される最大値で、Iの数値は1通りで表される
  # 1 <= a, b <= N + 1
  # [a, b]からpを選ぶ。ただし、a <= p, b / 2 < p, p <= bでなくてはならない
  # 遷移する先は
  #   p < bのとき[a2, b + p)であり
  #     a2 = max(a + p, b) (a + p <= N + 1のとき) <- a + p - 1 <= Nである (このときa + p - 1 < bだとまずいのでp >= b - a + 1
  #        = b             (その他)
  #
  #   p = bのとき[a, 2 * b)
  #   右端はN + 1とのminを取る
  for a in 1 ..< dp0.len:
    for b in a ..< dp0[0].len:
      let u = dp0[a][b]
      if u == 0: continue
      debug a, b, u, dp0v[a][b]
      if b >= N + 1:
        ans += u
        for v in dp0v[a][b]:
          stderr.write "found solve: ", v, "\n"
          vsolve.add v
      var l = max(a, b div 2 + 1)
      for p in l ..< b:
        if p > N: break
        if a + p - 1 <= N and p < b - a + 1: continue
        var a2 = min(b, N + 1)
        if a + p <= N + 1:
          a2.max= a + p
        debug p, a2
        if a2 <= N + 1:
          let b2 = min(b + p, N * 2)
          debug p, a2, b2
          dp0[a2][b2] += u
          for v in dp0v[a][b]:
            dp0v[a2][b2].add(v & p)
      if b <= N:
        if a + b - 1 <= N:
          dp0[a + b][2 * b] += u
          for v in dp0v[a][b]:
            dp0v[a + b][2 * b].add(v & b)
        else:
          dp0[a][2 * b] += u
          for v in dp0v[a][b]:
            dp0v[a][2 * b].add(v & b)


  echo ans
  Naive:
    var ans = mint(0)
    for b in 2^N:
      var a = Seq[int]
      for i in N:
        if b[i] == 1: a.add i + 1
      if test(a, N):
        #stderr.write "found: ", a, "\n"
        vsolve_naive.add a
        ans.inc
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  #echo test(@[1, 2, 3, 7, 8], 10)
  #for N in 1 .. 20:
  #  debug "test: ", N
  #  test(N)

  #test(11)
  solve(11)
  solve_naive(11)
  vsolve.sort
  vsolve_naive.sort
  for a in vsolve:
    if a notin vsolve_naive:
      echo "found solve: ", a

  for a in vsolve_naive:
    if a notin vsolve:
      echo "found solve_naive: ", a
  discard

