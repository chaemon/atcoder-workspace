const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve(L, R:int):
  let L2 = max(L, R div 10 + 1)
  echo R - L2 + 1
  discard

when not DO_TEST:
  let T = nextInt()
  for i in T:
    let L, R = nextInt()
    solve(L, R)
else:
  discard

