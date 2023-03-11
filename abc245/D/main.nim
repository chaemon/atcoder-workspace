const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], C:seq[int]):
  var C = C
  var B = newSeq[int](M + 1)
  for i in 0 .. M << 1:
    assert C[i + N] mod A[N] == 0
    B[i] = C[i + N] div A[N]
    for j in 0..N:
      C[i + j] -= A[j] * B[i]
  echo B.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N+1, nextInt())
  var C = newSeqWith(N+M+1, nextInt())
  solve(N, M, A, C)
else:
  discard

