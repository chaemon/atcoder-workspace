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
#}}}

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  data: seq[T]

proc initCumulativeSum[T](sz:int):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(sz, T(0)))

proc add[T](self: var CumulativeSum[T], k:int, x:T) =
  self.data[k] += x

proc build[T](self: var CumulativeSum[T]) =
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc `[]`[T](self: CumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  if s.a > s.b: return T(0)
  return self[s.b] - self[s.a - 1]
#}}}

proc solve(N:int, S:string) =
  E := initCumulativeSum[int](N + 3)
  W := initCumulativeSum[int](N + 3)
  for i,s in S:
    if s == 'E':E.add(i,1)
    elif s == 'W':W.add(i,1)
  E.build()
  W.build()
  var ans = int.inf
  for i in 0..<N:
    var s = W[0..i-1] + E[i+1..N-1]
#    echo W.query(0..i-1), " ", E.query(i+1..N-1), " ", s
    ans.min=s
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
#}}}
