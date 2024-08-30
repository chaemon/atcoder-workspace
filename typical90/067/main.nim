const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/math/convert_base

solveProc solve(N:int, K:int):
  var N = N
  for _ in K:
    var
      v = N.toSeq(9)
    N = v.toInt(8)
    for d in v.mitems:
      if d == 
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
