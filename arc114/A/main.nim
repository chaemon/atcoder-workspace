include atcoder/extra/header/chaemon_header

import atcoder/extra/math/eratosthenes
import atcoder/extra/other/bitutils

const DEBUG = true

proc solve(N:int, X:seq[int]) =
  var es = initEratosthenes(50)
  var p = es.prime
  ans := int.inf
  for b in 2^p.len:
    var T = 1
    for i in 0..<p.len:
      if b[i]: T *= p[i]
    var valid = true
    for i in 0..<N:
      if gcd(T, X[i]) == 1: valid = false;break
    if not valid: continue
    ans.min=T
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var X = newSeqWith(N, nextInt())
  solve(N, X)
#}}}

