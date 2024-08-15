when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  # f_i(f_j(x)) < f_j(f_i(x))となる条件
  # A[i] (A[j] x + B[j]) + B[i] < A[j] (A[i] x + B[i]) + B[j]
  # A[i] * B[j] + B[i] < A[j] * B[i] + B[j]
  # B[j] (A[i] - 1) < B[i] ( A[j] - 1)
  # (A[i] - 1) / B[i] < (A[j] - 1) / B[j]
  # (A[i] - 1) / B[i]の小さい順に適用すればよい
  var a = (0 ..< N).toSeq
  a.sort do (i, j:int) -> int:
    cmp(B[j] * (A[i] - 1),  B[i] * (A[j] - 1))
  var dp = Seq[K + 1: -int.inf]
  dp[0] = 1
  for i in N:
    var dp2 = dp
    for k in K:
      if dp[k] == -int.inf: continue
      let j = a[i]
      dp2[k + 1].max= A[j] * dp[k] + B[j]
    dp = dp2.move
  echo dp[K]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, K, A, B)
else:
  discard

