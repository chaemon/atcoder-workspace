const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, H:seq[int]):
  for i in N - 1:
    if H[i] < H[i + 1]:
      continue
    else:
      echo H[i];return
  echo H[^1]
  discard

when not DO_TEST:
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
else:
  discard

