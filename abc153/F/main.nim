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
var D:int
var A:int
var X:seq[int]
var H:seq[int]

# CumulativeSum (Imos){{{
import sequtils

type DualCumulativeSum[T] = object
  pos: int
  data: seq[T]

proc initDualCumulativeSum[T](sz:int = 100):DualCumulativeSum[T] = DualCumulativeSum[T](data: newSeqWith(sz, T(0)), pos: -1)
proc initDualCumulativeSum[T](a:seq[T]):DualCumulativeSum[T] =
  var data = a
  data.add(T(0))
  for i in 0..<a.len:
    data[i + 1] -= a[i]
  return DualCumulativeSum[T](data: data, pos: -1)
proc add[T](self: var DualCumulativeSum[T], s:Slice[int], x:T) =
  assert(self.pos < s.a)
  if s.a > s.b: return
  if self.data.len <= s.b + 1:
    self.data.setlen(s.b + 1 + 1)
  self.data[s.a] += x
  self.data[s.b + 1] -= x

proc `[]`[T](self: var DualCumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  if self.data.len <= k:
    self.data.setlen(k + 1)
  while self.pos < k:
    self.pos += 1
    if self.pos > 0: self.data[self.pos] += self.data[self.pos - 1]
  assert(k <= self.pos)
  return self.data[k]
#}}}

import future

#{{{ DualSegmentTree
type DualSegmentTree[OperatorMonoid] = object
  sz, height: int
  lazy: seq[OperatorMonoid]
  h: (OperatorMonoid, OperatorMonoid) -> OperatorMonoid
  OM0: OperatorMonoid

proc initDualSegmentTree[OperatorMonoid](n:int, h:(OperatorMonoid,OperatorMonoid)->OperatorMonoid, OM0:OperatorMonoid):DualSegmentTree[OperatorMonoid] =
  var
    sz = 1
    height = 0
  while sz < n: sz *= 2;height+=1
  return DualSegmentTree[OperatorMonoid](sz:sz, height:height, lazy:newSeqWith(2*sz, OM0), h:h, OM0:OM0)

proc propagate[OperatorMonoid](self: var DualSegmentTree[OperatorMonoid], k:int) =
  if self.lazy[k] != self.OM0:
    self.lazy[2 * k + 0] = self.h(self.lazy[2 * k + 0], self.lazy[k])
    self.lazy[2 * k + 1] = self.h(self.lazy[2 * k + 1], self.lazy[k])
    self.lazy[k] = self.OM0

proc thrust[OperatorMonoid](self: var DualSegmentTree[OperatorMonoid], k:int) =
  for i in countdown(self.height,1): self.propagate(k shr i)

proc update[OperatorMonoid](self: var DualSegmentTree[OperatorMonoid], p:Slice[int], x:OperatorMonoid) =
  var
    a = p.a + self.sz
    b = p.b + self.sz
  self.thrust(a)
  self.thrust(b)
  var
    l = a
    r = b + 1
  while l < r:
    if(l and 1) > 0: self.lazy[l] = self.h(self.lazy[l], x); l+=1
    if(r and 1) > 0: r-=1; self.lazy[r] = self.h(self.lazy[r], x)
    l = (l shr 1)
    r = (r shr 1)

proc `[]`[OperatorMonoid](self:var DualSegmentTree[OperatorMonoid], k:int):OperatorMonoid =
  var k = k + self.sz
  self.thrust(k)
  return self.lazy[k]
#}}}

proc solve() =
  x := newSeq[int](N)
  h := newSeq[int](N)
  v := newSeq[(int, int)]()
  for i in 0..<N:
    v.add((X[i], i))
  v.sort()
  for i in 0..<N:
    j := v[i][1]
    x[i] = X[j]
    h[i] = H[j]
#  st := initDualSegmentTree[int](N+1, (a:int,b:int)=>a+b, 0)
#  for i in 0..<N:
#    st.update(i..<i+1, h[i])
  cs := initDualCumulativeSum[int](h)
#  for i in 0..<N:
#    cs.add(i..<i+1, h[i])
  ans := 0
  for i in 0..<N:
#    t := st[i]
    t := cs[i]
    if t < 0: continue
    else:
      p := (t + A - 1) div A
      ans += p
      tail := x.lowerBound(x[i] + D*2+1)
#      st.update(i..<tail, - p * A)
      cs.add(i+1..<tail, - p * A)
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  D = nextInt()
  A = nextInt()
  X = newSeqWith(N, 0)
  H = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    H[i] = nextInt()
  solve()
#}}}
