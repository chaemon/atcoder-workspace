const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "YES"
const NO = "NO"

solveProc solve(N:int, S:string, T:string):
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

