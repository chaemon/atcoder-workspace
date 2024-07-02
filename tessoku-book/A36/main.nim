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
solveProc solve(N:int, K:int):
  if K mod 2 == 0 and K >= 2 * (N - 1): echo YES
  else: echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

