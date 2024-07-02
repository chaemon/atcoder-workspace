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
  var ct = Seq[S.len + 1: 0]
  for c in 'a' .. 'z':
    ct[S.count(c)].inc
  for i in 1 .. S.len:
    if ct[i] notin [0, 2]:
      echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

