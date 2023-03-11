const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:string):
  if S.toSet().len >= 3: echo YES
  else: echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

