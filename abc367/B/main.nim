when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:string):
  if X.find('.') == -1:
    echo X;return
  var X = X
  while X[^1] != '.':
    if X[^1] == '0':
      X = X[0 ..< ^1]
    else:
      break
  if X[^1] == '.':
    X = X[0 ..< ^1]
  echo X
  discard

when not defined(DO_TEST):
  var X = nextString()
  solve(X)
else:
  discard

