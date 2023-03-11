const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(x:seq[int], y:seq[int]):
  discard

when not DO_TEST:
  var x = newSeqWith(4, 0)
  var y = newSeqWith(4, 0)
  for i in 0..<4:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
else:
  discard

