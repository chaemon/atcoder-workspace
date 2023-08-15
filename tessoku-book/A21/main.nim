when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    A[i] = nextInt()
  solve(N, P, A)
else:
  discard

