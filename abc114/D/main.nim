#{{{ header
{.hints:off checks:off.}
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
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type someSignedInt = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someInteger = someSignedInt|someUnsignedInt
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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
#}}}

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

proc solve(N:int) =
  proc div_num(p:int):int =
    var N = N
    result = 0
    while N > 0:
      result += N div p
      N = N div p
  var v = newSeq[int]()
  var pd = initEratosthenes(100)
  for p in 2..100:
    if not pd.isPrime(p): continue
    d := div_num(p)
    if d <= 1: continue
    v.add(d)
  var ans = 0
  for a in 0..<v.len:
    for b in 0..<v.len:
      if b == a: continue
      for c in b+1..<v.len:
        if c == a: continue
        if v[a] >= 2 and v[b] >= 4 and v[c] >= 4: ans += 1
  for a in 0..<v.len:
    for b in 0..<v.len:
      if a == b: continue
      if v[a] >= 14 and v[b] >= 4: ans += 1
  for a in 0..<v.len:
    for b in 0..<v.len:
      if a == b: continue
      if v[a] >= 24 and v[b] >= 2: ans += 1
  for a in 0..<v.len:
    if v[a] >= 74: ans += 1
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  solve(N);
  return

main()
#}}}
