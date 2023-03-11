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

let YES = "Yes"
let NO = "No"

proc solve(N:int, t:seq[int], x:seq[int], y:seq[int]) =
  for i in 0..<N:
    var prev_t, prev_x, prev_y:int
    if i == 0:
      prev_t = 0;prev_x = 0;prev_y = 0
    else:
      prev_t = t[i-1];prev_x = x[i-1];prev_y = y[i-1]
    if abs(t[i] - prev_t) mod 2 != (abs(x[i] - prev_x) + abs(y[i] - prev_y)) mod 2:
      echo NO;return
    elif abs(t[i] - prev_t) < (abs(x[i] - prev_x) + abs(y[i] - prev_y)):
      echo NO;return
  echo YES
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var t = newSeqWith(N, 0)
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, t, x, y);
  return

main()
#}}}
