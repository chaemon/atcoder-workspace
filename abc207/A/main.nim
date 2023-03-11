const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(A:int, B:int, C:int):
  echo A + B + C - min([A, B, C])
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C, true)
#}}}

