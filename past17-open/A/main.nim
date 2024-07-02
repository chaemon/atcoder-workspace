when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

#100 * 100 * W / H^2 < 20

solveProc solve(H:int, W:int):
  if 100 * 100 * W < 20 * H^2:
    echo "A"
  elif 100 * 100 * W < 25 * H^2:
    echo "B"
  else:
    echo "C"
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
else:
  discard

