const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(a_x:int, a_y:int, b_x:int, b_y:int, c_x:int, c_y:int):
  discard

when not DO_TEST:
  var a_x = nextInt()
  var a_y = nextInt()
  var b_x = nextInt()
  var b_y = nextInt()
  var c_x = nextInt()
  var c_y = nextInt()
  solve(a_x, a_y, b_x, b_y, c_x, c_y)
else:
  discard

