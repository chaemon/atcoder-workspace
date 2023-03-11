const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(abc:int):
  var
    n = abc
    s = 0
  while n > 0:
    s += n mod 10
    n.div=10
  echo s * 111
  discard

when not DO_TEST:
  var abc = nextInt()
  solve(abc)
else:
  discard

