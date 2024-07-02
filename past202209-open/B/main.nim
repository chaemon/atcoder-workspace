when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:string):
  if N.len <= 2:
    echo 0
  else:
    echo N[0 .. ^3]
  discard

when not defined(DO_TEST):
  var N = nextString()
  solve(N)
else:
  discard

