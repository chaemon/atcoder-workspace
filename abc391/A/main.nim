when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(D:string):
  var D = D
  for d in D.mitems:
    if d == 'N':
      d = 'S'
    elif d == 'S':
      d = 'N'
    elif d == 'W':
      d = 'E'
    elif d == 'E':
      d = 'W'
  echo D
  discard

when not defined(DO_TEST):
  var D = nextString()
  solve(D)
else:
  discard

