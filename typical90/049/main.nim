const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, C:seq[int], L:seq[int], R:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var C = newSeqWith(M, 0)
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    C[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, C, L, R)
#}}}

