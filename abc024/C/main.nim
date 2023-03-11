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

import options

proc intersection(a, b: (int,int)):Option[(int,int)] = 
  if a[1] <= b[0] or b[1] <= a[0]: return none((int,int))
  else: return some((max(a[0], b[0]), min(a[1], b[1])))

proc solve(N:int, D:int, K:int, L:seq[int], R:seq[int], S:seq[int], T:seq[int]) =
  for z in zip(S, T):
    var p = (z.a, z.a+1)
    for d in 0..<D:
      var q = (L[d], R[d])
      var g = intersection(p, q)
      if g.isSome: p = (min(p[0], q[0]), max(p[1], q[1]))
      if p[0]<=z.b and z.b<p[1]:
        echo d + 1
        break
    discard
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var D = 0
  D = nextInt()
  var K = 0
  K = nextInt()
  var L = newSeqWith(D, 0)
  var R = newSeqWith(D, 0)
  for i in 0..<D:
    L[i] = nextInt()
    R[i] = nextInt() + 1
  var S = newSeqWith(K, 0)
  var T = newSeqWith(K, 0)
  for i in 0..<K:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, D, K, L, R, S, T);
  return

main()
#}}}
