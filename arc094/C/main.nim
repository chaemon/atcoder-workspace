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
type anyInt = int|int8|int16|int32|int64|BiggestInt
type anyUint = uint|uint8|uint16|uint32|uint64
type anyFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is anyFloat: T(Inf)
  elif T is anyInt|anyUint: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

proc solve(A:int, B:int, C:int) =
  var (A, B, C) = (A, B, C)
  let m = max(A, B, C)
  var ans = 0
  var d:int
  d = (m - A) div 2; ans += d; A += d * 2
  d = (m - B) div 2; ans += d; B += d * 2
  d = (m - C) div 2; ans += d; C += d * 2
  var t = 0
  if m > A: t += 1
  if m > B: t += 1
  if m > C: t += 1
  if t == 1: ans += 2
  elif t == 2: ans += 1
  echo ans
  return

#{{{ main function
proc main() =
  var A = 0
  A = nextInt()
  var B = 0
  B = nextInt()
  var C = 0
  C = nextInt()
  solve(A, B, C);
  return

main()
#}}}
