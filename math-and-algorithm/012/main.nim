const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/factorization

const YES = "Yes"
const NO = "No"

solveProc solve(N:int):
  let f = N.factor
  if f.len == 1:
    echo YES
  else:
    echo NO

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

