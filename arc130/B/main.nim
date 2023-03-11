const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, C:int, Q:int, t:seq[int], n:seq[int], c:seq[int]):
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var C = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var n = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    n[i] = nextInt()
    c[i] = nextInt()
  solve(H, W, C, Q, t, n, c)
else:
  discard

