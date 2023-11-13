const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, A:seq[seq[int]]):
  var ans = mint(1)
  for i in N:
    ans *= A[i].sum
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(6, nextInt()))
  solve(N, A)
#}}}

