when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(P:int, Q:int, S:seq[string], A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var P = nextInt()
  var Q = nextInt()
  var S = newSeqWith(P, nextString())
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
  solve(P, Q, S, A, B, C, D)
else:
  discard

