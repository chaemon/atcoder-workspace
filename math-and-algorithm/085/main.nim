const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, Y:int):
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  solve(N, X, Y)
else:
  discard

