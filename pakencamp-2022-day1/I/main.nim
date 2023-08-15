when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:int, Q:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var A = newSeqWith(P, 0)
  var B = newSeqWith(P, 0)
  for i in 0..<P:
    A[i] = nextInt()
    B[i] = nextInt()
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, P, Q, A, B, C, D)
else:
  discard

