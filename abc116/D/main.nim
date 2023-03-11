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

proc cumsum[T](v:seq[T]):seq[T] =
  result = newSeq[T]()
  result.add(T(0))
  for a in v: result.add(result[^1] + a)

proc getDefault[S](T:typedesc): T =
  when T is string: ""
  elif T is seq[S]: newSeq[int]()
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = (var temp:T;temp)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
#  discard self.hasKeyOrPut(key, cast[A]())
  discard self.hasKeyOrPut(key, newSeq[int]())
  tables.`[]`(self, key)

proc solve(N:int, K:int, t:seq[int], d:seq[int]) =
  var tb = initTable[int,seq[int]]()
  for i in 0..<N: tb[t[i]].add(d[i])
  var x, y = newSeq[int]()
  for p,v in tb.mpairs:
    v.sort()
    for i in 0..<v.len - 1:
      x.add(v[i])
    y.add(v[^1])
  x.sort;x.reverse
  xs := x.cumsum()
  y.sort;y.reverse
  s := 0
  var ans = 0
  for i in 0..<y.len:
    s += y[i]
    var t = i + 1
    if t > K: continue
    var rest = K - t
    if rest >= xs.len: continue
    a := s + t ^ 2 + xs[rest]
    ans.max=a
  echo ans

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var t = newSeqWith(N, 0)
  var d = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    d[i] = nextInt()
  solve(N, K, t, d);
  return

main()
#}}}

