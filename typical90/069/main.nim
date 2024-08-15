const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, K:int):
  if N == 1:
    echo mint(K)
  else:
    echo mint(K) * mint(K - 1) * mint(K - 2)^(N - 2)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

