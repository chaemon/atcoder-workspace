when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[seq[int]], Y:seq[seq[int]], Z:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, newSeqWith(2, nextInt()))
  var Y = newSeqWith(N, newSeqWith(2, nextInt()))
  var Z = newSeqWith(N, newSeqWith(2, nextInt()))
  solve(N, X, Y, Z)
else:
  discard

