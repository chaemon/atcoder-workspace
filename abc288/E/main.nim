when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], C:seq[int], X:seq[int]):
  Pred X
  var x = Seq[N: false]
  for i in X:
    x[i] = true
  var dp = Seq[N + 1, N + 1: -1]
  proc calc(i, j:int):int =
    r =& dp[i][j]
    if r >= 0: return r
    if i == N:
      r = 0
    elif j == N:
      r = int.inf
    else:
      doAssert i >= j
      r = int.inf
      if i > j:
        r.min=calc(i, j + 1)
      # A[i]を買わない
      if not x[i]:
        r.min=calc(i + 1, j + 1)
      # A[i]を買う
      r.min=calc(i + 1, j) + A[i] + C[j]
    return r
  echo calc(0, 0)

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  var X = newSeqWith(M, nextInt())
  solve(N, M, A, C, X)
else:
  discard

