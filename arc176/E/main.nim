when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, X:seq[int], Y:seq[int], A:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(N, nextInt())
  var Y = newSeqWith(N, nextInt())
  var A = newSeqWith(M, newSeqWith(N, nextInt()))
  solve(N, M, X, Y, A)
else:
  discard

