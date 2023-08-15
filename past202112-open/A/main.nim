when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(H:int, W:int, h:int, w:int):
  if h >= H and w <= W:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var h = nextInt()
  var w = nextInt()
  solve(H, W, h, w)
else:
  discard

