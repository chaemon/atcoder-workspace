when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, P:seq[int], T:seq[int], Q:int, q:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var P = newSeqWith(N-1, 0)
  var T = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    P[i] = nextInt()
    T[i] = nextInt()
  var Q = nextInt()
  var q = newSeqWith(Q, nextInt())
  solve(N, X, Y, P, T, Q, q)
else:
  discard

