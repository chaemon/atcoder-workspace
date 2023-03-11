const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int):
  ans := mint(0)
  p := mint(1)
  for b in 0 .. N - 1:
    var a = N - 1 - b
    if a mod 2 == 0:
      var a = a div 2
      ans += p * mint.fact(N * 2) * mint.rfact(b) * mint.rfact(a) * mint.rfact(N * 2 - a - b)
    p *= 3
  ans /= N
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

