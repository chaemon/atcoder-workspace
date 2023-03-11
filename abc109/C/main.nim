const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, X:int, x:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var x = Seq[N: nextInt()]
  solve(N, X, x, true)
#}}}

