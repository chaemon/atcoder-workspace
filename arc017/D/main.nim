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

#{{{ gcd and inverse
proc gcd(a,b:int):int=
  if b == 0: return a
  else: return gcd(b,a mod b)
proc lcm(a,b:int):int=
  return a div gcd(a, b) * b
# a x + b y = gcd(a, b)
proc extGcd(a,b:int, x,y:var int):int =
  var g = a
  x = 1
  y = 0
  if b != 0:
    g = extGcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g;
proc invMod(a,m:int):int =
  var
    x,y:int
  if extGcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
#}}}

var N:int
var a:seq[int]
var M:int
var t:seq[int]
var l:seq[int]
var r:seq[int]

import future

#{{{ LazySegmentTree[Monoid, OperatorMonoid](n,f,g,h,M1,OM0)

type LazySegmentTree[Monoid, OperatorMonoid] = object
  sz, height: int
  f: (Monoid, Monoid)->Monoid
  g: (Monoid, OperatorMonoid) -> Monoid
  h: (OperatorMonoid, OperatorMonoid) -> OperatorMonoid
  data: seq[Monoid]
  lazy: seq[OperatorMonoid]
  M1: Monoid
  OM0: OperatorMonoid

proc initLazySegmentTree[Monoid, OperatorMonoid](n: int, f: (Monoid, Monoid)->Monoid, g: (Monoid, OperatorMonoid)->Monoid, h:(OperatorMonoid, OperatorMonoid)->OperatorMonoid, M1: Monoid, OM0: OperatorMonoid): LazySegmentTree[Monoid, OperatorMonoid] =
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

proc build[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid,OperatorMonoid], v:seq[Monoid]) =
  var v = v
  while v.len < self.sz: v.add(self.M1)
  for i in 0..<self.sz:
    self.data[i + self.sz] = v[i]
  for k in countdown(self.sz - 1, 1):
    self.data[k] = self.f(self.data[2*k], self.data[2*k+1])

proc reflect[Monoid, OperatorMonoid](self:LazySegmentTree[Monoid, OperatorMonoid], k:int):Monoid =
  if self.lazy[k] == self.OM0:
    return self.data[k]
  else:
    return self.g(self.data[k], self.lazy[k])

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

proc update[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], p:Slice[int], x:OperatorMonoid) =
  let
    a = p.a + self.sz
    b = p.b + self.sz
  self.thrust(a)
  self.thrust(b)
  var
    l = a
    r = b + 1
  while l < r:
    if (l and 1) > 0: self.lazy[l] = self.h(self.lazy[l], x);l += 1
    if (r and 1) > 0: r -= 1;self.lazy[r] = self.h(self.lazy[r], x)
    l = (l shr 1);r = (r shr 1)
  self.recalc(a);
  self.recalc(b);

proc query[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], p:Slice[int]):Monoid =
  let
    a = p.a + self.sz
    b = p.b + self.sz
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
  return self.query(k..k)

proc findSubtree[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a:int, check:proc(a:Monoid):bool, M:var Monoid, t:int):int =
  var a = a
  while a < self.sz:
    self.propagate(a)
    let nxt = if t != 0: self.f(self.reflect(2 * a + t), M) else: self.f(M, self.reflect(2 * a + t))
    if check(nxt): a = 2 * a + t
    else: M = nxt;a = 2 * a + 1 - t
  return a - self.sz

proc findFirst[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], a:int, check:proc(a:Monoid):bool):int =
  var
    L = self.M1
    a = a
  if a <= 0:
    if check(self.f(L, self.reflect(1))): return self.find_subtree(1, check, L, 0)
    return -1
  self.thrust(a + self.sz)
  var b = self.sz
  a += self.sz
  b += self.sz
  while a < b:
    if (a and 1) > 0:
      let nxt = self.f(L, self.reflect(a))
      if check(nxt): return self.find_subtree(a, check, L, 0)
      L = nxt
      a += 1
    a = a shr 1
    b = b shr 1
  return -1;

proc findLast[Monoid, OperatorMonoid](self: var LazySegmentTree[Monoid, OperatorMonoid], b:int, check:proc(a:Monoid):bool):int =
  var
    R = self.M1
    b = b
  if b >= self.sz:
    if check(self.f(self.reflect(1), R)): return self.find_subtree(1, check, R, 1)
    return -1
  self.thrust(b + self.sz - 1)
  var a = self.sz
  b += self.sz
  while a < b:
    if (b and 1) > 0:
      b -= 1
      let nxt = self.f(self.reflect(b), R)
      if check(nxt): return self.find_subtree(b, check, R, 1)
      R = nxt;
    a = a shr 1
    b = b shr 1
  return -1


proc output[Monoid, OperatorMonoid](self: LazySegmentTree[Monoid, OperatorMonoid]) =

  var s = 1
  for h in 0..self.height:
    for i in s..<s*2: stdout.write self.data[i],"/",self.lazy[i], " - "
    echo ""
    s *= 2

#}}}

proc solve() =
#  st := initLazySegmentTree[int,int](N, (a:int,b:int)=>gcd(a,b), (a:int, b:int)=>a+b,(a:int,b:int)=>a+b,0,0)
  proc f(a, b:(int,int)):(int,int) =
    if a[0] == 0: return b
    elif b[0] == 0: return a
    elif a[0] != b[0] or a[1] > 0 or b[1] > 0: return (a[0], gcd(gcd(a[1], b[1]), abs(a[0] - b[0])))
    else: return a
  proc g(a:(int,int), d:int):(int,int) = (a[0] + d, a[1])
  st := initLazySegmentTree[(int,int),int](N, f, g,(a:int,b:int)=>a+b,(0,0),0)
  var a2 = newSeq[(int,int)]()
  for i in 0..<a.len: a2.add((a[i], 0))
  st.build(a2)
  ans := 0
  for i in 0..<M:
    if t[i] == 0:
      let p = st.query(l[i]..<r[i])
      echo gcd(p[0], p[1])
    else:
      st.update(l[i]..<r[i], t[i])
  return

#{{{ input part
block:
  N = nextInt()
  a = newSeqWith(N, nextInt())
  M = nextInt()
  t = newSeqWith(M, 0)
  l = newSeqWith(M, 0)
  r = newSeqWith(M, 0)
  for i in 0..<M:
    t[i] = nextInt()
    l[i] = nextInt() - 1
    r[i] = nextInt()
  solve()
#}}}
