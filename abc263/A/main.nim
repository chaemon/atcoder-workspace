const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(A:int, B:int, C:int, D:int, E:int):
  var P = [A, B, C, D, E].sorted
  if P[0] == P[1] and P[1] == P[2] and P[3] == P[4]:
    echo YES
  elif P[0] == P[1] and P[2] == P[3] and P[3] == P[4]:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var E = nextInt()
  solve(A, B, C, D, E)
else:
  discard

