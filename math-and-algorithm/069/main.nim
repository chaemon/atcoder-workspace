const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(a:int, b:int, c:int, d:int):
  discard

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(a, b, c, d)
else:
  discard

