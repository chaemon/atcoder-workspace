when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var
    lower = 0
    upper = 0
    S = S
  for i in S.len:
    if S[i].isLowerAscii:
      lower.inc
    else:
      upper.inc
  if lower > upper:
    for i in S.len:
      S[i] = S[i].toLowerAscii
  else:
    for i in S.len:
      S[i] = S[i].toUpperAscii
  echo S
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

