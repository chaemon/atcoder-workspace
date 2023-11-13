when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], L:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, nextInt())
  var L = newSeqWith(N, nextInt())
  solve(N, X, L)
else:
  discard

