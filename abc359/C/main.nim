when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S_x:int, S_y:int, T_x:int, T_y:int):
  discard

when not defined(DO_TEST):
  var S_x = nextInt()
  var S_y = nextInt()
  var T_x = nextInt()
  var T_y = nextInt()
  solve(S_x, S_y, T_x, T_y)
else:
  discard

