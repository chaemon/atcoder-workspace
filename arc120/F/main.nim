include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination
import atcoder/extra/dp/cumulative_sum

const DEBUG = true

proc solve(N:int, K:int, D:int, A:seq[int]) =
  doAssert D == 2
  if K == 1:
    doAssert false
  var cs = initCumulativeSum(N + 1, mint)
  for n in 0..N:
    let N2 = N - (K - 2)
    if N2 < K - 1: cs[n] = 0
    else: cs[n] = mint.C(N2, K - 1)
  var ans = mint(0)
  for i in 0..<N:
    var t = cs[i+1..N-2]
    if i > 0:
      let N2 = i - 1 - (K - 2)
      if N2 >= 0:
        t += mint.C(N2, K - 1)
    debug i, t
    ans += t * A[i]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var D = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, D, A)
#}}}

