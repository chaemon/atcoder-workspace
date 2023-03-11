const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(n:int, R:seq[int], C:seq[int], q:int, r:seq[int], c:seq[int]):
  discard

when not DO_TEST:
  var n = nextInt()
  var R = newSeqWith(n, nextInt())
  var C = newSeqWith(n, nextInt())
  var q = nextInt()
  var r = newSeqWith(q, 0)
  var c = newSeqWith(q, 0)
  for i in 0..<q:
    r[i] = nextInt()
    c[i] = nextInt()
  solve(n, R, C, q, r, c)
else:
  discard

