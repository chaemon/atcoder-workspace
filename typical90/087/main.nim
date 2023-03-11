const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, P:int, K:int, A:seq[seq[int]]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, P, K, A)
#}}}

