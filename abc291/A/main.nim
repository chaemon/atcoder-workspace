when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(S:string):
  var i = 1
  for s in S:
    if s in 'A'..'Z':
      echo i;break
    i.inc
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

