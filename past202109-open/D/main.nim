when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int, Y:int):
  proc divisor(n:int):seq[int] =
    for d in 1 .. n:
      if n mod d == 0: result.add d
  let
    x = X.divisor().len
    y = Y.divisor().len
  if x > y:
    echo "X"
  elif x < y:
    echo "Y"
  else:
    echo "Z"
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
else:
  discard

