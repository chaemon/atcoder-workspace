include atcoder/extra/header/chaemon_header
import atcoder/modint

const MOD = 998244353
var N:int
var K:int
var L:seq[int]
var R:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  L = newSeqWith(K, 0)
  R = newSeqWith(K, 0)
  for i in 0..<K:
    L[i] = nextInt()
    R[i] = nextInt()
#}}}

import atcoder/extra/math/formal_power_series

proc main() =
  type mint = modint998244353
  type FPS = FormalPowerSeries[mint]
#  var f = initFormalPowerSeries[mint](N)
  var f = FPS.init(N)
  for i in 0..<K:
    for j in L[i]..R[i]:
      if j < N:
        f[j] = mint(1)
  f = 1/(1 - f)
  echo f[N - 1]
  return

main()

