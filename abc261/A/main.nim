const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(L:seq[int], R:seq[int]):
  let
    l = max(L[0], L[1])
    r = min(R[0], R[1])
  if l > r:
    echo 0
  else:
    echo r - l
  discard

when not DO_TEST:
  var L = newSeqWith(2, 0)
  var R = newSeqWith(2, 0)
  for i in 0..<2:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(L, R)
else:
  discard

