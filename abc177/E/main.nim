include src/nim_acl/extra/header/chaemon_header

var N:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

import src/nim_acl/extra/math/eratosthenes

proc main() =
  var es = initEratosthenes(10^6)
  var g = 0
  for a in A: g = gcd(g, a)
  if g != 1:
    print "not coprime";return
  var ps = newSeqWith(10^6, false)
  for a in A:
    let f = es.factor(a)
    for (p, e) in f:
      if ps[p]: print "setwise coprime";return
      ps[p] = true
  print "pairwise coprime"
  return

main()
