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
solveProc solve(X:int, Y:int, Z:int, S:int):
  if X >= S or Y >= S or Z >= S:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  var S = nextInt()
  solve(X, Y, Z, S)
else:
  discard

