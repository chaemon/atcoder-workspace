when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int):
  var
    X = X
    ans = 0
  for i in X:
    if i mod 2 == 0: ans += 3
    else: ans -= 2
  echo ans
  discard

when not defined(DO_TEST):
  var X = nextInt()
  solve(X)
else:
  discard

