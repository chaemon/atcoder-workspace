when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S: string, T: string):
  for i in 0 .. S.len - T.len:
    if S[i ..< i + T.len] == T:
      echo YES; return
  echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

