const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(A:int, B:int):
  if B in A..6*A:
    echo YES
  else:
    echo NO
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B, true)
#}}}

