const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(A:int, B:int):
  echo  if A > 0 and B > 0:
      "Alloy"
    elif A > 0:
      "Gold"
    else:
      "Silver"
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

