include atcoder/extra/header/chaemon_header

import atcoder/extra/math/divisor

const DEBUG = true

proc solve(N:int, A:seq[int]) =
  let M = A.min
  tb := initTable[int,seq[int]]()
  for a in A:
    for t in a.divisor:
      if t <= M:
        if t notin tb: tb[t] = newSeq[int]()
        tb[t].add(a)
  ans := 0
  for t,a in tb:
    g := 0
    for a in a: g = gcd(a, g)
    if g == t:
      ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

