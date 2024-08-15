when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, A:seq[int16], B:seq[int16]):
  var dp = Seq[N + 1, X + 1: int16.inf]# 食べた数, 甘さの和 => しょっぱさの合計の最小値
  dp[0][0] = 0
  var ans = 0
  for i in N:
    var dp2 = dp
    for n in 0 .. i:
      for x in 0 .. X:
        if dp[n][x].isInf: continue
        ans.max=n + 1
        let
          x2 = x + A[i]
          y2 = dp[n][x] + B[i]
        if x2 > X or y2 > Y: continue
        dp2[n + 1][x2].min=y2
    dp = dp2.move
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, 0.int16)
  var B = newSeqWith(N, 0.int16)
  for i in 0..<N:
    A[i] = nextInt().int16
    B[i] = nextInt().int16
  solve(N, X, Y, A, B)
else:
  discard

