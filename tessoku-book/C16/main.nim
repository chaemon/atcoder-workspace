when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, A:seq[int], S:seq[int], B:seq[int], T:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, 0)
  var S = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var T = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    S[i] = nextInt()
    B[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, K, A, S, B, T)
else:
  discard

