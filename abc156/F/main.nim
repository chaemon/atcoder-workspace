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

const MOD = 2
var k:int
var q:int
var d:seq[int]
var n:seq[int]
var x:seq[int]
var m:seq[int]

#{{{ input part
block:
  k = nextInt()
  q = nextInt()
  d = newSeqWith(k-1-0+1, nextInt())
  n = newSeqWith(q, 0)
  x = newSeqWith(q, 0)
  m = newSeqWith(q, 0)
  for i in 0..<q:
    n[i] = nextInt()
    x[i] = nextInt()
    m[i] = nextInt()
#}}}

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

proc query(n, x, m:int): int =
  v := newSeq[int]()
  v0 := newSeq[int]()
  for j in 0..<k:
    md := d[j] mod m 
    if md == 0: md = m
    v.add(md)
    if md == 0: v0.add(1)
    else: v0.add(0)
  cs := initCumulativeSum(v)
#  cs0 := initCumulativeSum(v0)
  s := x mod m
  Q := (n - 1) div k
  R := (n - 1) mod k
  s += cs[0..<k] * Q + cs[0..<R]
#  s0 := cs0[0..<k] * Q + cs0[0..<R]
  return n - 1 - s div m # - s0

proc query2(n, x, m:int):int =
  a := newSeq[int](n)
  a[0] = x mod m
  for j in 1..<n:
    a[j] = (a[j-1] + d[(j-1) mod k]) mod m
  result = 0
  for j in 0..<n-1:
    if a[j] mod m < a[j+1] mod m: result += 1

block main:
#  for n in 1..<20:
#    echo "n = ", n
#    echo "query: ", query(n, 1, 7)
#    echo "query2: ", query2(n, 1, 7)
#  break

  for i in 0..<q:
    echo query(n[i], x[i], m[i])
  break
