const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(L:int, R:int):
  echo "atcoder"[L ..< R]
  discard

when not defined(DO_TEST):
  var L = nextInt() - 1
  var R = nextInt()
  solve(L, R)
else:
  discard

