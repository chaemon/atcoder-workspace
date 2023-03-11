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

proc solve(T:seq[int], A:var seq[int], B:var seq[int]) =
  var D = @[T[0] * A[0] + T[1] * A[1], T[0] * B[0] + T[1] * B[1]]
  if D[0] == D[1]: 
    echo "infinity"
    return
  if D[0] > D[1]: swap(D[0], D[1]);swap(A[0], B[0]);swap(A[1], B[1])
  # D[0] < D[1]
  if A[0] < B[0]: echo 0;return
  let diff = D[1] - D[0]
  var t = T[0] * A[0] - T[0] * B[0]
  var r = t mod diff
  var q = t div diff
  var ans = (q + 1) * 2 - 1
  if r == 0: ans -= 1
  echo ans
#  if abs(float(n) - nr) < EPS:
#    echo((n + 1) * 2 - 1 + 1)
#  else:
#    echo((n + 1) * 2 - 1)
#  return

#{{{ main function
proc main() =
  var T = newSeqWith(2, 0)
  for i in 0..<2:
    T[i] = nextInt()
  var A = newSeqWith(2, 0)
  for i in 0..<2:
    A[i] = nextInt()
  var B = newSeqWith(2, 0)
  for i in 0..<2:
    B[i] = nextInt()
  solve(T, A, B);
  return

main()
#}}}
