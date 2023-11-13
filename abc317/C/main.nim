when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  Pred A, B
  var adj = Seq[N, N: -1]
  for i in M:
    adj[A[i]][B[i]] = C[i]
    adj[B[i]][A[i]] = C[i]
  var dp = Seq[2^N, N: -int.inf]
  for u in N:
    dp[1 shl u][u] = 0
  for _ in N:
    var dp2 = dp
    for b in 2^N:
      for u in N:
        if dp[b][u] == -int.inf: continue
        for v in N:
          if b[v] == 1 or adj[u][v] == -1: continue
          dp2[b xor [v]][v].max=dp[b][u] + adj[u][v]
    dp = dp2.move
  var ans = -int.inf
  for i in dp.len:
    for j in dp[i].len:
      ans.max=dp[i][j]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, B, C)
else:
  discard

