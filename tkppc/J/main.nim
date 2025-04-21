when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(Q:int, T:seq[int], A:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var A = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    A[i] = nextInt()
    C[i] = nextInt()
  solve(Q, T, A, C)
else:
  discard

