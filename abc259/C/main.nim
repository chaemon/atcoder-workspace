const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string, T:string):
  discard

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

