const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var t = initTable[int, int]()
  for i in N:
    if A[i] notin t: t[A[i]] = 0
    t[A[i]].inc
  for i in M:
    if B[i] notin t or t[B[i]] == 0:
      echo NO;return
    t[B[i]].dec
  echo YES
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
else:
  discard

