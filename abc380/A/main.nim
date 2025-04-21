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
solveProc solve(N:string):
  if N.count('1') == 1 and N.count('2') == 2 and N.count('3') == 3:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextString()
  solve(N)
else:
  discard

