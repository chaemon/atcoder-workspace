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

var N:int
var D:int
var X:int
var Y:int

proc solve() =
  if abs(X) mod D != 0: echo 0.0;return
  if abs(Y) mod D != 0: echo 0.0;return
  x := abs(X) div D
  y := abs(Y) div D
  ans := 0.0
  for s in 0..N:
    if x > s or (s - x) mod 2 != 0: continue
    t := N - s
    if y > t or (t - y) mod 2 != 0: continue
    k := (s - x) div 2
    l := (t - y) div 2
    d := 1
    p := 1.0
    for i in 1..k:
      p *= d.float
      d += 1
      p /= i.float
      p *= 0.25
    for i in 1..k+x:
      p *= d.float
      d += 1
      p /= i.float
      p *= 0.25
    for i in 1..l:
      p *= d.float
      d += 1
      p /= i.float
      p *= 0.25
    for i in 1..l+y:
      p *= d.float
      d += 1
      p /= i.float
      p *= 0.25
    ans += p
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  D = nextInt()
  X = nextInt()
  Y = nextInt()
  solve()
#}}}
