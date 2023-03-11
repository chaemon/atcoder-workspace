const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, A:seq[int]):
  var dp = initTable[int, int]()
  dp[X] = 0 # 残りX円にするのに必要な枚数
  for i in 0..<N - 1:
    var dp2 = initTable[int, int]()
    for v, m in dp:
      # vはすべてA[i]の倍数
      let vl = (v div A[i + 1]) * A[i + 1]
      if vl notin dp2: dp2[vl] = int.inf
      dp2[vl].min= m + abs(vl - v) div A[i]
      if vl != v:
        let vr = vl + A[i + 1]
        if vr notin dp2: dp2[vr] = int.inf
        dp2[vr].min= m + abs(vr - v) div A[i]
    swap dp, dp2
  var ans = int.inf
  for v, m in dp:
    ans.min= m + v div A[^1]
  echo ans
  return

when not DO_TEST:
  let N = nextInt()
  let X = nextInt()
  let A= Seq[N:nextInt()]
  solve(N, X, A)
else:
  discard
