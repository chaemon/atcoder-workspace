const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/factorization

solveProc solve(N:int):
  echo N.factor.sorted.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

