include atcoder/extra/header/chaemon_header

const DEBUG = true

import atcoder/extra/other/binary_search

proc sqrt_i(n:int):int =
  if n < 0: return -1
  proc f(a:int):bool = a * a <= n
  let r = f.maxRight(0..2 * 10^9)
  assert r^2 <= n and n < (r + 1)^2
  return r

proc solve(X:float, Y:float, R:float) =
  let X = (X * 10000).round.int
  let Y = (Y * 10000).round.int
  let R = (R * 10000).round.int
  let x0 = ((X - R).floorDiv 10000) * 10000
  ans := 0
  for x in countup(x0, X + R, 10000):
    var t = sqrt_i(R^2 - (x - X)^2)
    if t == -1: continue
    ans += (Y + t).floorDiv(10000) - (Y - t).ceilDiv(10000) + 1
  echo ans
  return

# input part {{{
block:
  var X = nextFloat()
  var Y = nextFloat()
  var R = nextFloat()
  solve(X, Y, R)
#}}}

