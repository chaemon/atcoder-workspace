const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(a:int, b:int, c:int):
  if [a, b, c].sorted[1] == b:
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  solve(a, b, c)
else:
  discard

