when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, Q:int, P:seq[int], A:seq[int], T:seq[int], L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var P = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    A[i] = nextInt()
  var T = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, Q, P, A, T, L, R)
else:
  discard

