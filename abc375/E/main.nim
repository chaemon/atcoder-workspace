when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A
  if B.sum mod 3 != 0:
    echo -1;return
  let M = int(B.sum div 3)
  var dp = Seq[M + 1, M + 1: int16.inf]
  dp[0][0] = 0
  for i in N:
    var dp2 = Seq[M + 1, M + 1: int16.inf]
    for a in M + 1:
      for b in M + 1:
        if dp[a][b].isInf: continue
        # 0に入れる
        if a + B[i] <= M:
          var k = dp[a][b]
          if A[i] != 0: k.inc
          dp2[a + B[i]][b].min=k
        # 1に入れる
        if b + B[i] <= M:
          var k = dp[a][b]
          if A[i] != 1: k.inc
          dp2[a][b + B[i]].min=k
        # 2に入れる
        var k = dp[a][b]
        if A[i] != 2: k.inc
        dp2[a][b].min=k
    dp = dp2.move
  if dp[M][M].isInf:
    echo -1
  else:
    echo dp[M][M]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

