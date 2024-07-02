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
  if S[0] notin 'A' .. 'Z':
    echo NO;return
  for i in 1 ..< S.len:
    if S[i] notin 'a' .. 'z':
      echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

