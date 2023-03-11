const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(H:int, W:int, a:seq[seq[int]]):
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var a = Seq[H, W: nextInt()]
  solve(H, W, a, true)
#}}}

