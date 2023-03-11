const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, S)
else:
  discard

