const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:seq[string]):
  var ct = initTable[string, int]()
  for S in S:
    if S notin ct:
      ct[S] = 1
      echo S
    else:
      echo S,"(",ct[S],")"
      ct[S].inc
  discard

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

