include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var A = A
  A.sort
  ans := mint(1)
  ans *= A[0] + 1
  for i in 0..<N-1:
    ans *= A[i + 1] - A[i] + 1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

