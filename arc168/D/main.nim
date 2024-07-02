when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum_2d

solveProc solve(N:int, M:int, L:seq[int], R:seq[int]):
  Pred L, R
  var cs = Seq[N: initDualCumulativeSum2D[int16](N, N)]
  # cs[i][x, y]はx .. y内に含まれる帯について、iを含むものが存在するかどうか
  for j in M:
    let (L, R) = (L[j], R[j])
    for i in L .. R:
      cs[i].add(0 .. L, R ..< N, 1)
  for i in N: cs[i].build()
  var dp = Seq[N + 1, N + 1: 0]
  for d in 1 .. N:
    for i in 0 ..< N:
      # i ..< i + dについてやる
      let j = i + d
      if j > N: break
      for k in i ..< j:
        # 最後にマスkを埋める。つまり、kは開けておく
        if cs[k][i, j - 1] == 0: continue
        # i ..< kとk + 1 ..< jに分かれる
        dp[i][j].max= dp[i][k] + dp[k + 1][j] + 1
  echo dp[0][N]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, L, R)
else:
  discard

