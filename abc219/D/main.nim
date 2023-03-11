const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, X:int, Y:int, A:seq[int], B:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, X, Y, A, B)
else:
  discard

