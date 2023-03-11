const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  var W = Seq[N, N: int.inf]
  for i in 0..<N: W[i][i] = 0
  for i in 0..<M:
    W[A[i]][B[i]] = C[i]
  var ans = 0
  for k in 0..<N:
    for i in 0..<N:
      for j in 0..<N:
        let d = W[i][k] + W[k][j]
        if W[i][j] > d:
          W[i][j] = d
    for i in 0..<N:
      for j in 0..<N:
        if W[i][j] < int.inf:
          ans += W[i][j]
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
  solve(N, M, A, B, C)
#}}}

