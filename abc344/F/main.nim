when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[seq[int]], R:seq[seq[int]], D:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, newSeqWith(N, nextInt()))
  var R = newSeqWith(N, newSeqWith(N-1, nextInt()))
  var D = newSeqWith(N-1, newSeqWith(N, nextInt()))
  solve(N, P, R, D)
else:
  discard

