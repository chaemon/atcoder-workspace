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

import future

var N:int
var K:int
var x:seq[float]
var y:seq[float]
var c:seq[float]

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  x = newSeqWith(N, 0.0)
  y = newSeqWith(N, 0.0)
  c = newSeqWith(N, 0.0)
  for i in 0..<N:
    x[i] = nextFloat()
    y[i] = nextFloat()
    c[i] = nextFloat()
#}}}

proc sq(x:float):float = x * x

let EPS = 1e-10

proc find_min(a,b:float, f:(float)->float):float =
  let
    r = 2.0 / (3.0 + sqrt(5.0))
  var
    a = a
    b = b
    c = a + r * (b - a)
    d = b - r * (b - a)
    fc = f(c)
    fd = f(d)
  while d - c > EPS:
    if fc > fd: # '<': maximum, '>': minimum
      a = c; c = d; d = b - r * (b - a)
      fc = fd; fd = f(d)
    else:
      b = d; d = c; c = a + r * (b - a)
      fd = fc; fc = f(c)
  return c

proc f(X, Y:float):float =
  result = 0.0
  v := newSeq[float]()
  for i in 0..<N:
    v.add(c[i].float * sqrt((X - x[i]).sq + (Y - y[i]).sq))
  v.sort()
  return v[K - 1]

proc g(X):float =
  proc ff(Y:float):float = f(X, Y)
  let Ymin = find_min(-1000.0, 1000.0, ff)
  return f(X, Ymin)

main()

proc main() =
  let Xmin = find_min(-1000.0, 1000.0, g)
  echo g(Xmin).formatFloat(ffDecimal, 10)
  return
