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
solveProc solve(s:string, t:string):
  for i in 
  discard

when not defined(DO_TEST):
  var s = nextString()
  var t = nextString()
  solve(s, t)
else:
  discard

