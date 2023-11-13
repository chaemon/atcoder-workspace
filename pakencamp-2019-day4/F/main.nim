when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int], Q:int, S:seq[int], T:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  var C = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  var Q = nextInt()
  var S = newSeqWith(Q, 0)
  var T = newSeqWith(Q, 0)
  for i in 0..<Q:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, K, A, B, C, Q, S, T)
else:
  discard

