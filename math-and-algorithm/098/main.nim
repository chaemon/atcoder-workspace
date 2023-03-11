const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:seq[int], Y:seq[int], A:int, B:int):
  discard

when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, X, Y, A, B)
else:
  discard

