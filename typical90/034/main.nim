const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, K:int, a:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
#}}}

