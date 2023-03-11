const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:seq[string]):
  if S[0] == "#." and S[1] == ".#":
    echo NO
  elif S[1] == "#." and S[0] == ".#":
    echo NO
  else:
    echo YES
  return

when not DO_TEST:
  var S = newSeqWith(2, nextString())
  solve(S)
else:
  discard

