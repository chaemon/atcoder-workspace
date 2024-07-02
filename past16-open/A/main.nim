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
solveProc solve(M:int):
  if M in 4 .. 9:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var M = nextInt()
  solve(M)
else:
  discard

