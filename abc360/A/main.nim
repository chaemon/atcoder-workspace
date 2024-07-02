when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string):
  var R, M:int
  for i in 3:
    if S[i] == 'R': R = i
    elif S[i] == 'M': M = i
  if R < M:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

