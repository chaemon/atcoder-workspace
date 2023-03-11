const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, S:seq[string], T:seq[string]):
  t := T.toSet
  for s in S:
    if s in t:
      echo YES
    else:
      echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  var T = newSeqWith(M, nextString())
  solve(N, M, S, T)
else:
  discard

