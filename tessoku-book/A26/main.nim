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
solveProc solve(Q:int, X:seq[int]):
  discard

when not defined(DO_TEST):
  var Q = nextInt()
  var X = newSeqWith(Q, nextInt())
  solve(Q, X)
else:
  discard

