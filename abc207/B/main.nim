const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(A:int, B:int, C:int, D:int):
  let t = C * D - B
  if t <= 0: echo -1
  else:
    echo A.ceilDiv t
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D, true)
#}}}

