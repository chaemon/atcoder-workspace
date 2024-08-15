when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], A:seq[int], M:int, V:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var V = newSeqWith(M, nextInt())
  solve(N, P, A, M, V)
else:
  discard

