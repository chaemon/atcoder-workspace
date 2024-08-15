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
solveProc solve(N:int, T:int, A:int):
  let d = N - T - A
  if T + d < A or A + d < T:
    echo YES
  else:
    echo NO
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var A = nextInt()
  solve(N, T, A)
else:
  discard

