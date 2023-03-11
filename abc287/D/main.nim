when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string, T:string):
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

