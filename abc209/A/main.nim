const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(A:int, B:int):
  if A > B: echo 0
  else: echo B - A + 1
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

