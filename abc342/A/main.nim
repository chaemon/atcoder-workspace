when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  for i,c in S:
    if S.count(c) == 1:
      echo i + 1;break
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

