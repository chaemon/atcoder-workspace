#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

const MOD = 998244353

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v *= initModInt(a, Mod).v
  self.v = self.v mod MOD
proc `^=`(self:var ModInt[Mod], n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse(x:int):ModInt[Mod] =
  var (a, b) = (x, MOD)
  var (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u, Mod)
proc `/=`[T](a:var ModInt[Mod],b:T):void = a *= initModInt(b, Mod).v.inverse()
proc `+`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result += b
proc `-`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result -= b
proc `*`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result *= b
proc `/`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a; result /= b
proc `^`(a:ModInt[Mod],b:int):ModInt[Mod] = result = a; result ^= b
#}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)

#{{{ sieve_of_eratosthenes
type Eratosthenes = object
  pdiv:seq[int]

proc initEratosthenes(n:int):Eratosthenes =
  var pdiv = newSeq[int](n + 1)
  for i in 2..n:
    pdiv[i] = i;
  for i in 2..n:
    if i * i > n: break
    if pdiv[i] == i:
      for j in countup(i*i,n,i):
        pdiv[j] = i;
  return Eratosthenes(pdiv:pdiv)

proc isPrime(self:Eratosthenes, n:int): bool =
  return n != 1 and self.pdiv[n] == n

proc divisors(self:Eratosthenes, n:int):seq[int] =
  var n = n
  result = @[1]
  while n > 1:
    let p = self.pdiv[n]
    var
      result2 = result
      prod = 1
    while n mod p == 0:
      prod *= p
      for t in result:
        result2.add(t * prod)
      n = n div p
    swap(result, result2)
  result.sort(cmp[int])
#}}}

const B = 1000000

proc solve(N:int, A:seq[int]) =
  var e = initEratosthenes(B)
  var sum = newSeq[ModInt[Mod]](B+1)
  var ans = initMint(0)
  for i in 0..<N:
    let divs = e.divisors(A[i])
    for d in divs: sum[d] += A[i]
  for d in 1..<sum.len:
    if sum[d] == 0: continue
    var
      d2 = d
      prod = initMint(1)
    while d2 > 1:
      let p = e.pdiv[d2]
      var k = 0
      while d2 mod p == 0:
        d2 = d2 div p
        k += 1
      prod *= (initMint(1)/(initMint(p)^(k - 1)) - initMint(1)/(initMint(p)^k))
      prod *= initMint(-1)
#      if k mod 2 == 1: prod *= initMint(-1)
    ans += sum[d] * sum[d] * prod
  ans -= initMint(sum(A))
  ans/=2
#    echo d, " ", sum[d] * sum[d], " ", sum[d] * sum[d] * prod, " ", prod
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N-1-0+1, 0)
  for i in 0..<N-1-0+1:
    A[i] = nextInt()
  solve(N, A);
  return

main()
#}}}
