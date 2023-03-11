const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, C:seq[int]):
  var ans = mint(1)
  for i in 0..<N:
    let p = C[i] - i
    if p < 0:
      echo 0
      return
    ans *= p
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var C = newSeqWith(N, nextInt())
  C.sort
  solve(N, C)
#}}}

