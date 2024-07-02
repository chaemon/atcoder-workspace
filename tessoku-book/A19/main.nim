when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, W:int, w:seq[int], v:seq[int]):
  var dp = Seq[W + 1: -int.inf]
  dp[0] = 0
  for i in N:
    var dp2 = dp
    for j in 0 .. W:
      if dp[j] == -int.inf: continue
      if j + w[i] <= W:
        dp2[j + w[i]].max=dp[j] + v[i]
    dp = dp2.move
  echo dp.max
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var W = nextInt()
  var w = newSeqWith(N, 0)
  var v = newSeqWith(N, 0)
  for i in 0..<N:
    w[i] = nextInt()
    v[i] = nextInt()
  solve(N, W, w, v)
else:
  discard

