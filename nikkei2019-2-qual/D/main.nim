#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

proc sort[T](a:var seq[T]) = a.sort(cmp[T])

template `:=`(a, b: untyped): untyped =
  when declaredInScope a:
    a = b
  else:
    var a = b
  when not declared seiuchi:
    proc seiuchi(x: auto): auto {.discardable.} = x
  seiuchi(x = b)
#}}}

#{{{ segment tree range_update
import future

type SegmentTree[T] = object
  sz:int
  data:seq[T]
  M1:T
  f:(T,T)->T

proc newSegmentTree[T](n:int,f:(T,T)->T,M1:T):SegmentTree[T] =
  var sz = 1
  while sz < n: sz *= 2
  var st = SegmentTree[T](sz:sz,data:newSeqWith(sz*2, M1),M1:M1,f:f)
  return st

proc set[T](self:var SegmentTree[T], k:int, x:T) =
  self.data[k + self.sz] = x

proc build[T](self:var SegmentTree[T]) =
  for k in countdown(self.sz-1,1):
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1]);
proc query[T](self:var SegmentTree[T], k:int):T =
  var k = k + self.sz
  result = self.data[k]
  while true:
    k = (k shr 1)
    if k == 0: break
    result = self.f(result, self.data[k])

proc update[T](self: var SegmentTree[T], a,b:int, x:T) =
  var
    (a,b) = (a + self.sz, b + self.sz)
  while a < b:
    if a mod 2 == 1: self.data[a] = self.f(x, self.data[a]);a += 1
    if b mod 2 == 1: b -= 1;self.data[b] = self.f(self.data[b], x)
    a = (a shr 1)
    b = (b shr 1)

proc `[]`[T](self:SegmentTree[T],k:int):T = self.data[k + self.sz]
#}}}

#{{{ LazySegmentTree[Monoid, OperatorMonoid](n,f,g,h,M1,OM0)
type LazySegmentTree[Monoid, OperatorMonoid] = object
  sz, height: int
#  f: (Monoid, Monoid)->Monoid
#  g: (Monoid, OperatorMonoid) -> Monoid
#  h: (OperatorMonoid, OperatorMonoid) -> OperatorMonoid
  f: proc(a:Monoid, b:Monoid):Monoid
  g: proc(a:Monoid, b:OperatorMonoid):Monoid
  h: proc(a:OperatorMonoid, b:OperatorMonoid):OperatorMonoid
  data: seq[Monoid]
  lazy: seq[OperatorMonoid]
  M1: Monoid
  OM0: OperatorMonoid

proc newLazySegmentTree[Monoid, OperatorMonoid](n: int, f: proc(a,b:Monoid):Monoid, g: proc(a:Monoid, b:OperatorMonoid): Monoid, h:proc(a,b:OperatorMonoid):OperatorMonoid, M1: Monoid, OM0: OperatorMonoid): LazySegmentTree[Monoid, OperatorMonoid] =
  var
    sz = 1
    height = 0
  while sz < n: sz *= 2;height += 1
  var
    data = newSeqWith(sz * 2, M1)
    lazy = newSeqWith(sz * 2, OM0)
  return LazySegmentTree[Monoid, OperatorMonoid](sz:sz, height:height, f:f, g:g, h:h, data:data, lazy:lazy, M1:M1, OM0:OM0)

proc set[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid,OperatorMonoid], k:int, x:Monoid) =
  self.data[k + self.sz] = x

proc build[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid,OperatorMonoid]) =
  for k in countdown(self.sz - 1, 1):
    self.data[k] = self.f(self.data[2*k], self.data[2*k+1])

proc reflect[Monoid, OperatorMonoid](self:LazySegmentTree[Monoid, OperatorMonoid], k:int):Monoid =
  return if self.lazy[k] == self.OM0: self.data[k] else: self.g(self.data[k], self.lazy[k])


proc propagate[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], k:int) =
  if self.lazy[k] != self.OM0:
    self.lazy[2 * k + 0] = self.h(self.lazy[2 * k + 0], self.lazy[k])
    self.lazy[2 * k + 1] = self.h(self.lazy[2 * k + 1], self.lazy[k])
    self.data[k] = self.reflect(k)
    self.lazy[k] = self.OM0

proc recalc[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], k:int) =
  var k = k div 2
  while k > 0:
    self.data[k] = self.f(self.reflect(2 * k + 0), self.reflect(2 * k + 1))
    k = k div 2

proc thrust[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], k:int) =
  for i in countdown(self.height, 1):
    self.propagate(k shr i)

proc update[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a,b:int, x:OperatorMonoid) =
  let
    a = a + self.sz
    b = b + self.sz - 1
  self.thrust(a)
  self.thrust(b)
  var
    l = a
    r = b + 1
  while l < r:
    if (l and 1) > 0: self.lazy[l] = self.h(self.lazy[l], x);l += 1
    if (r and 1) > 0: r -= 1;self.lazy[r] = self.h(self.lazy[r], x)
    l = l shr 1;r = r shr 1
  self.recalc(a);
  self.recalc(b);

proc query[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a,b:int):Monoid =
  let
    a = a + self.sz
    b = b + self.sz - 1
  self.thrust(a)
  self.thrust(b)
  var
    L = self.M1
    R = self.M1
    l = a
    r = b + 1
  while l < r:
    if (l and 1) > 0: L = self.f(L, self.reflect(l));l += 1
    if (r and 1) > 0: r -= 1;R = self.f(self.reflect(r), R)
    l = l shr 1;r = r shr 1
  return self.f(L, R);

proc `[]`[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], k:int):Monoid =
  return self.query(k, k + 1)

proc find_subtree[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a:int, check:proc(a:Monoid):bool, M:Monoid, t:int):int =
  while a < self.sz:
    self.propagate(a)
    let nxt = if t != 0: self.f(self.reflect(2 * a + t), M) else: self.f(M, self.reflect(2 * a + t))
    if check(nxt): a = 2 * a + t
    else: M = nxt;a = 2 * a + 1 - t
  return a - self.sz

proc find_first[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a:int, check:proc(a:Monoid):bool):int =
  var L = self.M1
  if a <= 0:
    if check(self.f(L, self.reflect(1))): return self.find_subtree(1, check, L, false)
    return -1
  self.thrust(a + self.sz)
  var b = self.sz
  a += self.sz
  b += self.sz
  while a < b:
    if (a and 1) > 0:
      let nxt = self.f(L, self.reflect(a))
      if check(nxt): return self.find_subtree(a, check, L, false)
      L = nxt
      a += 1
    a = a shr 1
    b = b shr 1
  return -1;

proc find_last[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], b:int, check:proc(a:Monoid):bool):int =
  var R = self.M1
  if b >= self.sz:
    if check(self.f(self.reflect(1), R)): return self.find_subtree(1, check, R, true)
    return -1
  self.thrust(b + self.sz - 1)
  var a = self.sz
  b += self.sz
  while a < b:
    if (b and 1) > 0:
      b -= 1
      let nxt = self.f(self.reflect(b), R)
      if check(nxt): return self.find_subtree(b, check, R, true)
      R = nxt;
    a = a shr 1
    b = b shr 1
  return -1;
#}}}

proc solve(N:int, M:int, L:seq[int], R:seq[int], C:seq[int]) =
#  var st = newSegmentTree[int](N, (a:int, b:int) => min(a,b), int.infty)
  var st = newLazySegmentTree[int,int](N, (a:int, b:int) => min(a,b), (a:int, b:int) => min(a,b), (a:int, b:int) => min(a,b), int.infty, int.infty)
  v := newSeq[(int,int,int)]()
  for i in 0..<M: v.add((L[i], R[i], C[i]))
  v.sort()
  i := 0
  st.update(0, 1, 0)
  for u in 0..<N:
    d := st.query(u, u + 1)
    if u == N - 1:
      if d == int.infty: echo -1
      else: echo d
      return
    while i < M and v[i][0] == u:
      st.update(v[i][0] + 1, v[i][1] + 1, d + v[i][2])
      i += 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt(1)
    R[i] = nextInt(1)
    C[i] = nextInt()
  solve(N, M, L, R, C);
  return

main()
#}}}
