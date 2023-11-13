when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:seq[int], L:seq[int], C:seq[int], K:seq[int]):
  let INF = K[1] + 1
  var dp = Seq[K[0] + 1: INF] # dp[k]: 1個目のセンサーをk個使った場合の2個目のセンサーの最小値
  dp[0] = 0
  for i in N:
    var dp2 = Seq[K[0] + 1: INF]
    for k in 0 .. K[0]:
      if dp[k] == INF: continue
      var t = 0 # 1個目のセンサーをt個使う
      while true:
        if k + t > K[0]: break
        let d = D[i] - t * L[0]
        var u = max(0, d.ceilDiv(L[1]))
        dp2[k + t].min=dp[k] + u
        if d < 0: break
        t.inc
    dp = dp2.move
    #debug i, dp
  ans := int.inf
  for i in 0 .. K[0]:
    if dp[i] == INF: continue
    doAssert dp[i] in 0 .. K[1]
    ans.min= C[0] * i + C[1] * dp[i]
  if ans == int.inf:
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = newSeqWith(N, nextInt())
  var L = newSeqWith(2, 0)
  var C = newSeqWith(2, 0)
  var K = newSeqWith(2, 0)
  for i in 0..<2:
    L[i] = nextInt()
    C[i] = nextInt()
    K[i] = nextInt()
  solve(N, D, L, C, K)
else:
  discard

