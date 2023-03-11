#{{{ header
{.hints:off warnings:off optimization:speed.}
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

var N:int
var K:int
var A:seq[int]

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  built:bool
  data: seq[T]

proc initCumulativeSum[T](sz:int = 100):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(sz, T(0)), built:false)
proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = CumulativeSum[T](data: data, built:false)
  result.build()
proc add[T](self: var CumulativeSum[T], k:int, x:T) =
  if self.data.len < k + 1:
    self.data.setlen(k + 1)
  self.data[k] += x

proc build[T](self: var CumulativeSum[T]) =
  self.built = true
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc `[]`[T](self: CumulativeSum[T], k:int):T =
  assert(self.built)
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  assert(self.built)
  if s.a > s.b: return T(0)
  return self[s.b] - self[s.a - 1]
#}}}

proc solve() =
  var v = newSeq[int]()
  for i in 0..<N-1:
    if A[i] < A[i+1]: v.add(1)
    else: v.add(0)
  cs := initCumulativeSum(v)
  var ans = 0
  for i in 0..N-K:
    if cs[i..<i+K-1] == K - 1:
      ans += 1
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
  solve()
#}}}
