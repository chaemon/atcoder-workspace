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
solveProc solve(x_A:int, y_A:int, x_B:int, y_B:int, x_C:int, y_C:int):
  var
    da = (x_B - x_C)^2 + (y_B - y_C)^2
    db = (x_C - x_A)^2 + (y_C - y_A)^2
    dc = (x_A - x_B)^2 + (y_A - y_B)^2
    v = [da, db, dc]
  v.sort
  if v[2] == v[0] + v[1]:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var x_A = nextInt()
  var y_A = nextInt()
  var x_B = nextInt()
  var y_B = nextInt()
  var x_C = nextInt()
  var y_C = nextInt()
  solve(x_A, y_A, x_B, y_B, x_C, y_C)
else:
  discard

