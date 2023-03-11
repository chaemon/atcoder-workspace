const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/math/combination

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int):
  for k in 1 .. N:
    n := 1
    d := N
    ans := mint(0)
    while d >= n:
      ans += mint.C(d, n)
      # k - 1個ずつずらす
      d -= k - 1
      n.inc
    echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
