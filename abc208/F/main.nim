const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/math/lagrange_polynomial

solveProc solve(N:int, M:int, K:int):
  var p, f = Seq[M + 1: mint]
  var v = newSeq[mint]()
  for n in 0..<K + M + 5:
    if n == 0:
      for m in 0..M: f[n] = 0
    else:
      f[0] = mint(n)^K
      for m in 1..M:
        f[m] = p[m] + f[m - 1]
    v.add(f[M])
#    p = move(f)
    swap(f, p)
  echo lagrange_polynomial(v, N)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K, true)
#}}}
