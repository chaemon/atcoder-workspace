when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(C:int, H:int):
  if H >= 2800:
    echo "o"
  else:
    echo "x"
  discard

when not defined(DO_TEST):
  var C = nextInt()
  var H = nextInt()
  solve(C, H)
else:
  discard
