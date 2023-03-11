#{{{ header
{.hints:off warnings:off.}
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

#{{{ main function
proc main() =
  let N = nextInt()
  var C = newSeqWith(N, nextInt())
  let Q = nextInt()
  var
    allMin = C.min
    evenMin = int.inf
    d = 0
    evenD = 0
  proc get(i:int):int =
    if i mod 2 == 0:
      return C[i] - d - evenD
    else:
      return C[i] - d
  proc getEvenMin():int =
    return evenMin - evenD - d
  proc getMin():int =
    min(allMin - d, getEvenMin())
  for i in 0..<N:
    if i mod 2 == 0: evenMin.min=(C[i])
  var ans = 0
  for q in 0..<Q:
    let t = nextInt()
    if t == 1:
      let
        x = nextInt() - 1
        a = nextInt()
      let rest = get(x)
      if rest >= a:
        C[x] -= a
        allMin.min=C[x]
        if x mod 2 == 0:
          evenMin.min=C[x]
        ans += a
    elif t == 2:
      let a = nextInt()
      if getEvenMin() >= a:
        evenD += a
        ans += a * ((N + 1) div 2)
    else:
      let a = nextInt()
      if getMin() >= a:
        d += a
        ans += a * N
  echo ans
  return

main()
#}}}
