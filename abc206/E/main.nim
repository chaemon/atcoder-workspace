include atcoder/extra/header/chaemon_header

const DEBUG = true
const DO_TEST = false

import atcoder/extra/math/eratosthenes
import atcoder/extra/other/bitutils

solveProc solve(L:int, R:int):
  if L == R:
    if L == 1: echo 0
    else: echo 0
    return
  var ans = (R - L + 1)^2
  var es = initEratosthenes()
  # reletively prime
  for x in L..R:
    if x == 1: continue
    # y in x + 1 ..< R + 1
    let p = es.factor(x)
    var s = 0
    for b in 0..<2^p.len:
      var ct = 0
      var prod = 1
      for i in 0..<p.len:
        if not b[i]: continue
        prod *= p[i][0]
        ct.inc
      if ct mod 2 == 0:
        s += ceilDiv(R + 1, prod) - ceilDiv(x + 1, prod)
      else:
        s -= ceilDiv(R + 1, prod) - ceilDiv(x + 1, prod)
    ans -= 2 * s
  # x divides y and x != y
  for x in L..R:
    let s = ceilDiv(R + 1, x) - 2
    ans -= 2 * s
  # x = y
  for x in L..R:
    ans -= 1
  echo ans
  return

# input part {{{
when not DO_TEST:
  var L = nextInt()
  var R = nextInt()
  solve(L, R, true)
#}}}

