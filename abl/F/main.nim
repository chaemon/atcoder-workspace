include atcoder/extra/header/chaemon_header
import atcoder/convolution
import atcoder/extra/math/montgomery_modint
#import atcoder/modint
import atcoder/extra/math/combination

const MOD = 998244353
var N:int
var h:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  h = newSeqWith(2*N, nextInt())
#}}}

#type mint = modint998244353
declareMontgomery(mint, MOD)

import deques
#proc `<`(a, b:seq[mint]):bool = a.len < b.len

proc main() =
  var tb = initTable[int,int]()
  for h in h:
    if h notin tb: tb[h] = 0
    tb[h].inc

#  var q = initHeapQueue[seq[mint]]()
  var q = initDeque[seq[mint]]()
  for h, x in tb:
    let L = x div 2
    var v = newSeq[mint](L+1)
    for n in 0..L:
      v[n] = mint.C(x, 2 * n) * mint.fact(2 * n) / (mint(2).pow(n) * mint.fact(n))
    q.addLast(v)
  while q.len > 1:
    let
      x = q.popFirst
      y = q.popFirst
    q.addLast(convolution(x, y))
  var s = q.popFirst

  for i in 0..<s.len:
    let m = N - i
    if m < 0: continue
    s[i] *= mint.fact(m * 2)/(mint(2).pow(m) * mint.fact(m))
  var ans = mint(0)
  for i in 0..<s.len:
    if i mod 2 == 0:
      ans += s[i]
    else:
      ans -= s[i]
  echo ans
  return

main()

