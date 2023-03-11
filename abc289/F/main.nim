when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(s_x:int, s_y:int, t_x:int, t_y:int, a:int, b:int, c:int, d:int):
  discard

when not defined(DO_TEST):
  var s_x = nextInt()
  var s_y = nextInt()
  var t_x = nextInt()
  var t_y = nextInt()
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(s_x, s_y, t_x, t_y, a, b, c, d)
else:
  discard

