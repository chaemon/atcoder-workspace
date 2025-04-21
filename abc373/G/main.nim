when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, A, B, C, D)
else:
  discard

