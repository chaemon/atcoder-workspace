when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, m:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var m = newSeqWith(N, nextInt())
  solve(N, X, m)
else:
  discard

