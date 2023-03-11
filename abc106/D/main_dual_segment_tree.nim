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

import future

#{{{ initDualSegmentTree[OperatorMonoid](n, h)
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

proc solve(N:int, M:int, Q:int, L:seq[int], R:seq[int], p:seq[int], q:seq[int]) =
  var st = initDualSegmentTree[int](510, (a:int,b:int)=>a+b, 0)
  var v = newSeq[tuple[e:int, i: int, s:int]]() # end, start
  for i in 0..<M:v.add((R[i], -1, L[i]))
  for j in 0..<Q:v.add((q[j], j, p[j]))
  v.sort()
  var ans = newSeq[int](Q)
  i := 0
  ct := 0
  while i < v.len:
    var i2 = i
    while i2 < v.len and v[i].e == v[i2].e:
      if v[i2].i == -1: st.update(v[i2].s..<st.sz, 1);ct += 1
      else:
        ans[v[i2].i] = ct - st[v[i2].s - 1]
      i2 += 1
    i = i2
  for a in ans:
    echo a
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var Q = 0
  Q = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
  var p = newSeqWith(Q, 0)
  var q = newSeqWith(Q, 0)
  for i in 0..<Q:
    p[i] = nextInt()
    q[i] = nextInt()
  solve(N, M, Q, L, R, p, q);
  return

main()
#}}}
