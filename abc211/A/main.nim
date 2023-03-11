const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(A:int, B:int):
  echo (A - B) / 3 + B
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

