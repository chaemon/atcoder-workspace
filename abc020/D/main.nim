include lib/header/chaemon_header

import lib/math/eratosthenes
import lib/math/divisor

const MOD = 1000000007
var N:int
var K:int

proc solve() =
  var es = initEratosthenes()
  var prime_divisors = newSeq[int]()
  block:
    var i = 0
    var K2 = K
    while K2 > 1:
      let p = es.getPrime(i)
      if p * p > K2: break
      prime_divisors.add p
      while K2 mod p == 0: K2.div=p
      i.inc
    if K2 > 1: prime_divisors.add K2

  var ans = 0
  for d in K.divisor:
    let K2 = K div d
    var pd = newSeq[int]()
    for p in prime_divisors:
      if K2 mod p == 0: pd.add p
    let B = 1 shl pd.len
    var ans0 = 0;
    for b in 0..<B:
      var pr = 1
      for i in pd.len:
        if (b and (1 shl i)) > 0: pr *= pd[i]
      var
        s = N div (d*pr)
        t = s * (s+1) div 2
      assert t >= 0
      t.mod=MOD;t*=pr;t.mod=MOD
      if b.popCount() mod 2 == 0:
        ans0 += t
      else:
        ans0 -= t
      ans0 = (ans0 mod MOD + MOD) mod MOD
    ans0*=K;ans0.mod=MOD
    ans+=ans0;ans.mod=MOD
  echo ans

#{{{ input part
block:
  N = nextInt()
  K = nextInt()
  solve()
#}}}
