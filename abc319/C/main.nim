when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(c:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var c = newSeqWith(3, newSeqWith(3, nextInt()))
  solve(c)
else:
  discard

