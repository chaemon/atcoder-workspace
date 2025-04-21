when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, C:seq[int], X:seq[int]):
  Pred C
  var
    dp, dp1 = Seq[N, N: int.inf]
    # dp[i][j]: i .. jを変えるコスト, dp1[i][j]を包含
    # dp1[i][j]: i .. jの下地を最初にやる場合のコスト

  for i in N:
    dp[i][i] = 1 + X[C[i]]
    dp1[i][i] = dp[i][i]
  proc next(i: int):int =
    if i == N - 1: 0
    else: i + 1
  proc prev(i: int):int =
    if i == 0: N - 1
    else: i - 1
  for d in 2 .. N:
    for i in N:
      var j = i + d - 1
      if j >= N: j -= N
      # dp1[i][j]を決める
      if C[i] == C[j]:
        let C0 = C[i]
        if d >= 3:
          dp1[i][j].min= dp[next(i)][prev(j)] + X[C0] + d
        else:
          dp1[i][j].min=X[C0] + 2
        var k = i
        #dp1[i][j].min=dp[
        while true:
          # i .. kとk .. jに分ける
          if k != i and k != j and not dp[i][k].isInf and not dp[k][j].isInf:
            dp1[i][j].min= dp1[i][k] + dp1[k][j] - X[C0] - 1
          if k == j: break
          k = next(k)
      else:
        dp1[i][j] = int.inf
      # dp[i][j]を決める
      dp[i][j].min= dp1[i][j]
      var k = i
      #dp1[i][j].min=dp[
      while true:
        # i .. kとk + 1 .. jに分ける
        let k2 = k.next
        if not dp[i][k].isInf and not dp[k2][j].isInf:
          dp[i][j].min= dp[i][k] + dp[k2][j]
        if k2 == j: break
        k = k2
  var ans = int.inf
  for i in N:
    var j = i
    while true:
      if next(j) == i:
        ans.min=dp[i][j]
      else:
        let
          j2 = next(j)
          i2 = prev(i)
        # i .. jとj2 .. i2
        ans.min=dp[i][j] + dp[j2][i2]
      j = next(j)
      if i == j: break
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var C = newSeqWith(N, nextInt())
  var X = newSeqWith(N, nextInt())
  solve(N, C, X)
else:
  discard

