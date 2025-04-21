when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int], K:int, X:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var K = nextInt()
  var X = newSeqWith(K, 0)
  var Y = newSeqWith(K, 0)
  for i in 0..<K:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, A, B, K, X, Y)
else:
  discard

