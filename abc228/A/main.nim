const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:int, T:int, X:int):
  var t = S
  while t != T:
    if t == X: echo YES; return
    t.inc
    if t == 24: t = 0
  echo NO
  return

when not DO_TEST:
  var S = nextInt()
  var T = nextInt()
  var X = nextInt()
  solve(S, T, X)
else:
  discard

