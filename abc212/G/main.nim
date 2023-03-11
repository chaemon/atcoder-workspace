const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/math/divisor

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc assert2(b:bool) =
  if not b:
    while true:
      discard

solveProc solve(P:int):
  var f = prime_factorization(P - 1)
  var F = 1
  for (p,e) in f:
    F *= p^e
  assert F == P - 1
  var ans = mint(1) # (0, 0)
  for g in (P - 1).divisor:
    assert (P - 1) mod g == 0
    var T0 = (P - 1) div g
    var T = T0
    for (p,e) in f:
      if T0 mod p == 0:
        T.div= p
        T *= (p - 1)
    ans += T * mint((P - 1) div g)
  echo ans
  return

# input part {{{
when not DO_TEST:
  var P = nextInt()
  solve(P)
#}}}

