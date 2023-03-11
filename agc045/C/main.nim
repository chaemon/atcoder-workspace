const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, A:int, B:int):
  var (A, B) = (A, B)
  if A > B: swap A, B
  var dp, dp1 = Seq[B:mint]
  # dp[i]: 長さがi, 0はA個以上並ぶ
  # dp1[i]: 最後が1
  dp[0] = 1
  dp1[0] = 1
  for i in 0..B - 2:
    # dp[i]を確定
    # 1にする
    dp[i + 1] += dp[i]
    dp1[i + 1] += dp[i]
    # 0にする
    # dp1[i]から0を連ねる
    for j in A..B:
      if i + j >= B: break
      dp[i + j] += dp1[i]
  var a, b = Seq[N + 1:mint]
  # a: 長さA未満の0連で終わる
  # b: dpで終わる(最後は1)
  for t in 0 ..< A:
    a[t] = 1
  b[0] = 0
  for i in 0..<N:
    # a[i], b[i]が決まっている
    # a -> b
    if i > 0:
      for t in 0 .. B - 2:
        # 最初は1 最後も1
        if i + t + 1 > N: break
        b[i + t + 1] += a[i] * dp1[t]
    else:
      for t in 1 .. B - 1:
        if i + t > N: break
        b[i + t] += a[i] * dp1[t]
    # b -> a
    # t個のA連を追加
    for t in 1 ..< A:
      if i + t > N: break
      a[i + t] += b[i]
  var ans = mint(0)
  # 最後dpで終わる
  for j in 0 .. B - 2:
    let l = N - 1 - j
    # a[l] 1 dp[j]
    ans += a[l] * dp[j]
  # 最後長さA未満の0連で終わる
  for t in 1 ..< A:
    let l = N - t
    # b[l] 0..0
    ans += b[l]
  ans = mint(2)^N - ans
  echo ans
  Naive:
    proc encode(a:seq[int]):int =
      var p = 1
      for i in N:
        result += p * a[i]
        p *= 2
    proc decode(n:int):seq[int] =
      var n = n
      for i in N:
        result.add n mod 2
        n.div=2
    var vis = Seq[2^N:false]
    proc dfs(u:int) =
      if vis[u]: return
      vis[u] = true
      var a = u.decode
      for i in N:
        var a = a
        if i + A - 1 >= N: break
        for j in i ..< i + A:
          a[j] = 0
        dfs(a.encode)
      for i in N:
        var a = a
        if i + B - 1 >= N: break
        for j in i ..< i + B:
          a[j] = 1
        dfs(a.encode)
    dfs(0)
    echo vis.count(true)
  discard

when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  test(17, 1, 1)
  #for N in 20:
  #  for A in 1..N:
  #    for B in 1..N:
  #      echo "test for", N, " ", A, " ", B
  #      test(N, A, B)
