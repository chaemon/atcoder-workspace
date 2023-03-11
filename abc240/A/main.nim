const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(a:int, b:int):
  discard

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  solve(a, b)
else:
  discard

