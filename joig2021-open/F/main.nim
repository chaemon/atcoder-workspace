const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(H:int, W:int, S:int, A:seq[seq[int]]):
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var S = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, S, A, true)
#}}}

