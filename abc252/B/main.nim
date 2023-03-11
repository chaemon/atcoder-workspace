const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  var M = A.max
  for i in K:
    if A[B[i] - 1] == M:
      echo YES
      return
  echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(K, nextInt())
  solve(N, K, A, B)
else:
  discard

