const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(X:int):
  if X > 0 and X mod 100 == 0: echo YES
  else: echo NO
  return

when not DO_TEST:
  var X = nextInt()
  solve(X)
else:
  discard

