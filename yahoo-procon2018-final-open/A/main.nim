import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false

proc discardableId[T](x: T): T {.discardable.} =
  return x
template `:=`(x, y: untyped): untyped =
  when defined(x):
    (x = y; discardableId(x))
  else:
    (var x = y; discardableId(x))


#{{{ sieve_of_eratosthenes
var pdiv = newSeq[int]()

proc sieve_of_eratosthenes(n:int) =
  pdiv.setLen(n)
  for i in 2..<n:
    pdiv[i] = i;
  for i in 2..<n:
    if i * i >= n: break
    if pdiv[i] == i:
      for j in countup(i*i,n-1,i):
        pdiv[j] = i;

proc is_prime(n:int): bool =
  return n!=1 and pdiv[n] == n
#}}}


proc solve(N:int, M:int, a:seq[int]):void =
  sieve_of_eratosthenes(100010)
  var ct = newSeqWith(100010, 0)
  for i in 0..<N:
    var
      a = a[i]
      v = newSeq[int]()
    while a > 1:
      let p = pdiv[a]
      v.add(p)
      while a mod p == 0:
        a = a div p
    let B = (1 shl v.len)
    for b in 0..<B:
      var q = 1
      for i in 0..<v.len:
        if (b and (1 shl i)) != 0: q *= v[i]
      ct[q] += 1
  for i in 1..M:
    var
      ii = i
      v = newSeq[int]()
      ans = 0
    while ii > 1:
      let p = pdiv[ii]
      v.add(p)
      while ii mod p == 0:
        ii = ii div p
    let B = (1 shl v.len)
    for b in 0..<B:
      var
        q = 1
        c = 0
      for i in 0..<v.len:
        if (b and (1 shl i)) != 0: q *= v[i];c += 1
      if c mod 2 == 0: ans += ct[q]
      else: ans -= ct[q]
    echo ans

  discard


proc main():void =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, M, a);
  return

main()
