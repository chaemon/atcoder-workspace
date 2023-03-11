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

proc solve(N:int, Q:int, S:string, l:seq[int], r:seq[int]) =
  var v = newSeq[int]()
  for i in 0..<N - 1:
    if S[i] == 'A' and S[i+1] == 'C': v.add(i)
  for q in 0..<Q:
    echo v.lowerBound(r[q] - 1) - v.lowerBound(l[q])
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var Q = 0
  Q = nextInt()
  var S = ""
  S = nextString()
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt() - 1
    r[i] = nextInt()
  solve(N, Q, S, l, r);
  return

main()
#}}}
