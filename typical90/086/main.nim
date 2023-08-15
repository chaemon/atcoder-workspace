const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/other/bitutils

solveProc solve(N:int, Q:int, x:seq[int], y:seq[int], z:seq[int], w:seq[int]):
  Pred x, y, z
  ans := mint(1)
  for d in 60:
    s := mint(0)
    for b in 2^N:
      ok := true
      for i in Q:
        if (b[x[i]] or b[y[i]] or b[z[i]]) != w[i][d]:
          ok = false
      if ok:
        s.inc
    ans *= s
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  var z = newSeqWith(Q, 0)
  var w = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
    z[i] = nextInt()
    w[i] = nextInt()
  solve(N, Q, x, y, z, w)
