when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, P:seq[int], B:seq[int], W:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  var B = newSeqWith(N, 0)
  var W = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    B[i] = nextInt()
    W[i] = nextInt()
    C[i] = nextInt()
  solve(N, X, P, B, W, C)
else:
  discard

