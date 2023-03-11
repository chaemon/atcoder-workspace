const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, B, C)
else:
  discard

