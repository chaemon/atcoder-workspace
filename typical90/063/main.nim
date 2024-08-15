const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/other/bitutils

solveProc solve(H:int, W:int, P:seq[seq[int]]):
  var ans = -int.inf
  for b in 1 ..< 2^H:
    var ct = Seq[H * W: 0]
    for j in W:
      var
        u = -1
        ok = true
      for i in H:
        if b[i] == 0: continue
        if u == -1: u = P[i][j]
        elif u != P[i][j]: ok = false;break
      if u == -1 or not ok: continue
      ct[u - 1].inc
    ans.max=popCount(b) * ct.max
  echo ans
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var P = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, P)
