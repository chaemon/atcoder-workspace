when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, M:int, T:seq[int], A:seq[int], X:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var M = nextInt()
  var T = newSeqWith(M, 0)
  var A = newSeqWith(M, 0)
  var X = newSeqWith(M, 0)
  for i in 0..<M:
    T[i] = nextInt()
    A[i] = nextInt()
    X[i] = nextInt()
  solve(H, W, M, T, A, X)
else:
  discard

