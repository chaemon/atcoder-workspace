when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var i = S.len - 1
  while S[i] != '.': i.dec
  echo S[i + 1 .. ^1]
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

