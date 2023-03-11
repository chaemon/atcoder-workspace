include atcoder/extra/header/chaemon_header

var N:int

# input part {{{
proc main()
block:
  N = nextInt()
#}}}

#{{{ sieve_of_eratosthenes
when not defined ATCODER_ERATOSTHENES_HPP:
  const ATCODER_ERATOSTHENES_HPP = 1
  type Eratosthenes* = object
    pdiv:seq[int]
  
  proc initEratosthenes*(n:int):Eratosthenes =
    var pdiv = newSeq[int](n + 1)
    for i in 2..n:
      pdiv[i] = i;
    for i in 2..n:
      if i * i > n: break
      if pdiv[i] == i:
        for j in countup(i*i,n,i):
          pdiv[j] = i;
    return Eratosthenes(pdiv:pdiv)
  proc isPrime*(self:Eratosthenes, n:int): bool =
    return n != 1 and self.pdiv[n] == n
  proc factor*(self:Eratosthenes, n:int): seq[(int,int)] =
    result = newSeq[(int,int)]()
    var n = n
    while n > 1:
      let p = self.pdiv[n]
      var e = 0
      while n mod p == 0: e.inc;n = n div p
      result.add (p, e)
#}}}

proc main() =
  var es = initEratosthenes(10^7)
  var ans = 0
  for C in 1..<N:
    let p = N - C
    var f = es.factor(p)
    var e = initTable[int,int]()
    var t = 1
    for (k,v) in f:
      t *= v + 1
    ans += t
  print ans
  return

main()

