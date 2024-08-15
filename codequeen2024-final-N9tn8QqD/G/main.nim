when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, C:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = newSeqWith(N, nextInt())
  solve(N, C)
else:
  discard

