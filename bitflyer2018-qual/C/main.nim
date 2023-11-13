when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:int, X:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var X = newSeqWith(N, nextInt())
  solve(N, D, X)
else:
  discard

