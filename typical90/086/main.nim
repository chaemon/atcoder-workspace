const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, Q:int, x:seq[int], y:seq[int], z:seq[int], w:seq[int]):
  return

# input part {{{
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
#}}}

