const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, A:seq[int]):
  if X in A:
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
else:
  discard

