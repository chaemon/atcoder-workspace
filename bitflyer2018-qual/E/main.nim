when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(Y:int, W:int, N:int, M:int, D:int, A:seq[int], B:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var Y = nextInt()
  var W = nextInt()
  var N = nextInt()
  var M = nextInt()
  var D = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    B[i] = nextInt()
    C[i] = nextInt()
  solve(Y, W, N, M, D, A, B, C)
else:
  discard

