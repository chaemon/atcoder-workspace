const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, C:int, A:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var C = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, C, A)
#}}}

