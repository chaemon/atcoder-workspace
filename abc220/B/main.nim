const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(K:int, A:string, B:string):
  var A0, B0 = 0
  for a in A:
    A0 *= K
    A0 += a.ord - '0'.ord
  for a in B:
    B0 *= K
    B0 += a.ord - '0'.ord
  echo A0 * B0
  return

when not DO_TEST:
  var K = nextInt()
  var A = nextString()
  var B = nextString()
  solve(K, A, B)
else:
  discard

