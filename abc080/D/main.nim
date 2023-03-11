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

# CumulativeSum (Imos){{{
import sequtils

type DualCumulativeSum[T] = object
  built:bool
  data: seq[T]

proc initDualCumulativeSum[T](sz:int = 100):DualCumulativeSum[T] = DualCumulativeSum[T](data: newSeqWith(sz, T(0)), built:false)
proc initDualCumulativeSum[T](data:seq[T]):DualCumulativeSum[T] =
  result = DualCumulativeSum[T](data: data, built:false)
  result.build()
proc add[T](self: var DualCumulativeSum[T], s:Slice[int], x:T) =
  assert(not self.built)
  if self.data.len <= s.b + 1:
    self.data.setlen(s.b + 1)
  self.data[s.a] += x
  self.data[s.b + 1] -= x

proc build[T](self: var DualCumulativeSum[T]) =
  self.built = true
  self.data[0] = T(0)
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc `[]`[T](self: DualCumulativeSum[T], k:int):T =
  assert(self.built)
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
#}}}

var N:int
var C:int
var s:seq[int]
var t:seq[int]
var c:seq[int]

proc solve() =
  cs := initDualCumulativeSum[int](100100)
  a := newSeqWith(C, newSeq[(int,int)]())
  for i in 0..<N:
    a[c[i]].add((s[i], t[i]))
  for t in 0..<C:
    if a[t].len == 0: continue
    a[t].sort()
    var i = 0
    while i < a[t].len:
      let start = a[t][i][0]
      var j = i + 1
      while j < a[t].len and a[t][j - 1][1] == a[t][j][0]: j += 1
      let end_time = a[t][j-1][1]
      cs.add(start..end_time,1)
      i = j
  cs.build()
  ans := 0
  for t in 0..<100010:
    ans.max=cs[t]
  echo ans

#{{{ input part
block:
  N = nextInt()
  C = nextInt()
  s = newSeqWith(N, 0)
  t = newSeqWith(N, 0)
  c = newSeqWith(N, 0)
  for i in 0..<N:
    s[i] = nextInt()
    t[i] = nextInt()
    c[i] = nextInt() - 1
  solve()
#}}}
