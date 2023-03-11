const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(a:int, b:int, c:int):
  if a < c^b:
    echo YES
  else:
    echo NO
  return

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  solve(a, b, c)
