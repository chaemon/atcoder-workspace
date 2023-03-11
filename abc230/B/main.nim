const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string):
  var T = "oxx".repeat(30)
  if T.find(S) == -1:
    echo NO
  else:
    echo YES
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

