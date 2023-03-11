const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

import atcoder/dsu
include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var
    ct = Seq[N:0]
    dsu = initDsu(N)
  for i in M:
    ct[A[i]].inc
    ct[B[i]].inc
    if dsu.leader(A[i]) == dsu.leader(B[i]): echo NO;return
    dsu.merge(A[i], B[i])
  for i in N:
    if ct[i] >= 3: echo NO;return
  echo YES
  return


when not DO_TEST:
  let N, M = nextInt()
  var A, B = Seq[M:int]
  for i in M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
else:
  discard

