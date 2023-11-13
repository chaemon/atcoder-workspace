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
solveProc solve(N:int):
  var N = N
  while N mod 2 == 0:
    N.div=2
  while N mod 3 == 0:
    N.div=3
  if N == 1:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

