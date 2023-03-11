const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, L:int, A:seq[int], B:seq[int], C:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, L, A, B, C, true)
#}}}

