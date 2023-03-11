when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int, Y:int, Z:int):
  var
    X = X
    Y = Y
    Z = Z
  if X < 0:
    X *= -1
    Y *= -1
    Z *= -1
  if Y notin 0 .. X:
    echo X;return
  doAssert Y in 0 .. X
  if Y < Z:
    echo -1;return
  if Z < 0:
    echo (-Z) * 2 + X
  else:
    echo X
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  solve(X, Y, Z)
else:
  discard

