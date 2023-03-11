const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(A:int, B:int, C:int):
  if B * C <= A: echo C
  else: echo A / B
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}

