include atcoder/extra/header/chaemon_header

#import atcoder/modint
import atcoder/extra/math/modint_montgomery
import atcoder/extra/math/combination

const MOD = 998244353

type mint = modint998244353

proc solve(N:int, d:seq[int]) =
  s := d.sum - N
  var p, v, w = mint(1)
  for i in 0..<N: p *= d[i]
  for i in 1..N - 2: p *= i
  p *= mint.C_large(s, N - 2)
  echo p
  return

# input part {{{
block:
  var N = nextInt()
  var d = newSeqWith(N, nextInt())
  solve(N, d)
#}}}
