const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, P:seq[int], Q:seq[int]):
  var (P, Q) = (P, Q)
  var a = Seq[tuple[P, Q:int]]
  for i in N: a.add (P[i], Q[i])
  a.sort
  for i in N:
    P[i] = a[i].P
    Q[i] = a[i].Q
  var revQ = Seq[N:int]
  for i in N:
    revQ[Q[i]] = i
  var
    vis = Seq[N: false]
    ans = mint(1)
  for s in N:
    if vis[s]: continue
    # 選ばないものに印をつける
    # uに印をつけるとu+1はつけられない
    var
      u = s
      n = 0
    while true:
      n.inc
      vis[u] = true
      u = revQ[u]
      if u == s: break
    proc calc2(n:int):mint =
      if n < 0: return 0
      var dp = Seq[2: mint(0)]
      # dp[0]: 最後に印をつけない
      # dp[1]: 最後に印をつける
      dp[0] = 1
      for i in n:
        var dp2 = Seq[2: mint(0)]
        dp2[0] = dp[0] + dp[1]
        dp2[1] = dp[0]
        swap dp, dp2
      return dp[0] + dp[1]
    proc calc(n:int):mint =
      if n == 1: return 1
      elif n == 2: return 3
      result = 0
      # n - 1につけない => 0〜n-2までの付け方を決める
      result += calc2(n - 1)
      # n - 1につける => 0, n - 2にはつけられない。1〜n-3までの付け方を決める
      result += calc2(n - 3)
    ans *= calc(n)
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  var Q = newSeqWith(N, nextInt() - 1)
  solve(N, P, Q)
else:
  discard

