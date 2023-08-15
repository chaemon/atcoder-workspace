when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  let
    S = A.sum
    r = S.floorMod(N)
    q = S.floorDiv(N)
  var s = 0
  # r個がq + 1, 残りがq
  var dp = r + 1 @ int.inf
  dp[0] = 0
  for i in N:
    s += A[i]
    # i + 1個まで決める
    var dp2 = r + 1 @ int.inf
    for k in 0 .. r:
      if dp[k] == int.inf: continue
      # q + 1にする
      if k < r:
        let d = (q + 1) * (k + 1) + q * (i - k)
        dp2[k + 1].min=dp[k] + abs(d - s)
      # qにする
      let d = (q + 1) * k + q * (i + 1 - k)
      dp2[k].min=dp[k] + abs(d - s)
    dp = dp2.move
  echo dp[r]
  discard


when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

