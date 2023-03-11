const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, u:seq[int], v:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, u, v, true)
#}}}

