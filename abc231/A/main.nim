const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(D:int):
  echo D / 100
  return

when not DO_TEST:
  let D = nextInt()
  solve(D)
else:
  discard

