const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(n:int):
  if n >= 5:
    echo YES
  elif 2^n > n^2:
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var n = nextInt()
  solve(n)
else:
  discard

