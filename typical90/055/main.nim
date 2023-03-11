const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 7
type mint = modint7

solveProc solve(N:int, P:int, Q:int, A:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, Q, A)
#}}}

