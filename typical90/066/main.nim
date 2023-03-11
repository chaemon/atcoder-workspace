const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, L:seq[int], R:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, L, R)
#}}}

