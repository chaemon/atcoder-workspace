include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

#const DEBUG = true

proc solve(N:int, A:seq[int]) =
  s := mint(0)
  ans := mint(0)
  for i in 0..<N:
    debug i, s
    ans += s * A[i]
    s *= 2
    s += A[i]
  debug ans
  for i in 0..<N:
    ans += mint(A[i]) * A[i]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  A.sort
  solve(N, A)
#}}}

