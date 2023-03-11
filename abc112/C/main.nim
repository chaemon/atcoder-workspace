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


proc solve(N:int, x:seq[int], y:seq[int], h:seq[int]) =
  proc test(CX, CY:int):int =
    var H = -1
    var Hmax = int.inf
    for i in 0..<N:
      let d = abs(x[i] - CX) + abs(y[i] - CY)
      if h[i] == 0:
        Hmax.min= d
      else:
        if H > 0:
          if max(H - d, 0) != h[i]: return -1
        else:
          H = h[i] + d
    if H > 0 and H <= Hmax: return H
    else: return -1
  for CX in 0..100:
    for CY in 0..100:
      let H = test(CX, CY)
      if H > 0:
        echo CX, " ", CY, " ", H
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var h = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    h[i] = nextInt()
  solve(N, x, y, h);
  return

main()
#}}}
