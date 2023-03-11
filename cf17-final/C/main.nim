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
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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


proc diff(a,b:int):int =
  let d = abs(a - b)
  return min(d, 24 - d)

proc solve(N:int, D:seq[int]) =
  var a = newSeqWith(24, false)
  a[0] = true
  var ans = int.inf
  for i in 0..<N:
    for d in 0..<24:
      if a[d]:
        ans.min=diff(d, D[i])
        if D[i] != 0:
          ans.min=diff(d, 24 - D[i])
    a[D[i]] = true
    if D[i] != 0: a[24 - D[i]] = true
  echo ans

  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
  solve(N, D);
  return

main()
#}}}
