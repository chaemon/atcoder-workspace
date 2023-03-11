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

#{{{ toInt(seq[int], b = 10), toSeq(n: int, b = 10, min_digit)
proc toInt(d: seq[int], b = 10):int =
  result = 0
  var p = 1
  for di in d:
    result += p * di
    p *= b
proc toSeq(n: int, b = 10, min_digit = -1):seq[int] =
  result = newSeq[int]()
  var n = n
  while n > 0:result.add(n mod b); n = n div b
  if min_digit >= 0:
    while result.len < min_digit: result.add(0)
#}}}

proc solve(n:int) =
  var v = toSeq(n)
  for d in v.mitems:
    if d == 1: d = 9
    elif d == 9: d = 1
  echo v.toInt()
  return

#{{{ main function
proc main() =
  var n = 0
  n = nextInt()
  solve(n);
  return

main()
#}}}
