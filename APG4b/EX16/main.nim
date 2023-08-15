when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "YES"
const NO = "NO"
solveProc solve(A:seq[int]):
  discard

when not defined(DO_TEST):
  var A = newSeqWith(5, nextInt())
  solve(A)
else:
  discard

