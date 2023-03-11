const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Possible"
const NO = "Impossible"

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], P:seq[int], Q:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  var P = newSeqWith(M-1, 0)
  var Q = newSeqWith(M-1, 0)
  for i in 0..<M-1:
    P[i] = nextInt()
    Q[i] = nextInt()
  solve(N, M, A, B, P, Q)
#}}}

