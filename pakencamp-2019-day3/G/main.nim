when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], M:int, B:seq[int], Q:int, T:seq[int], C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, A, M, B, Q, T, C, D)
else:
  discard

