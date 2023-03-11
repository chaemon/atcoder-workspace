const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

