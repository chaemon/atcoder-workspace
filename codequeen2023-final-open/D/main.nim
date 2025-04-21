when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(R:int, C:int, r_s:int, c_s:int, r_t:int, c_t:int):
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var C = nextInt()
  var r_s = nextInt()
  var c_s = nextInt()
  var r_t = nextInt()
  var c_t = nextInt()
  solve(R, C, r_s, c_s, r_t, c_t)
else:
  discard

