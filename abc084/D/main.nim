#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

var Q:int
var l:seq[int]
var r:seq[int]

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
#}}}

proc solve() =
  const N = 100000
  es := initEratosthenes(N)
  v := newSeq[int]()
  for p in countup(3, N, 2):
    if es.isPrime(p) and es.isPrime((p + 1) div 2):
      v.add(p)
  for q in 0..<Q:
    echo v.lower_bound(r[q] + 1) - v.lower_bound(l[q])
  return

#{{{ main function
proc main() =
  Q = nextInt()
  l = newSeqWith(Q, 0)
  r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt()
    r[i] = nextInt()
  solve()
  return

main()
#}}}
