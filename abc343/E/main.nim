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
solveProc solve(V:seq[int]):
  discard

when not defined(DO_TEST):
  var V = newSeqWith(3, nextInt())
  solve(V)
else:
  discard

