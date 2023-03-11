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
var h:seq[int]
var a:seq[int]

import future

#{{{ segment tree: initSegmentTree[T](n, f:(T, T)->T, M1:T)
type SegmentTree[T] = object
  sz:int
  data:seq[T]
  M1:T
  f:(T,T)->T

proc initSegmentTree[T](n:int,f:(T,T)->T,M1:T):SegmentTree[T] =
  var sz = 1
  while sz < n: sz *= 2
  return SegmentTree[T](sz:sz,data:newSeqWith(sz*2,M1),M1:M1,f:f)

proc set[T](self:var SegmentTree[T], k:int, x:T) =
  self.data[k + self.sz] = x

proc build[T](self:var SegmentTree[T], v:seq[T]) =
  var v = v
  while v.len < self.sz: v.add(self.M1)
  for i in 0..<v.len: self.data[self.sz + i] = v[i]
  for k in countdown(self.sz-1,1):
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1]);
proc update[T](self:var SegmentTree[T], k:int, x:T) =
  var k = k + self.sz
  self.data[k] = x
#  self.data[k] = self.f(self.data[k], x)
  while true:
    k = (k shr 1)
    if k == 0: break
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1])

proc query[T](self:SegmentTree[T],p:Slice[int]):T =
  var
    (L,R) = (self.M1, self.M1)
    (a,b) = (p.a + self.sz, p.b + 1 + self.sz)
  while a < b:
    if a mod 2 == 1: L = self.f(L, self.data[a]);a += 1
    if b mod 2 == 1: b -= 1;R = self.f(self.data[b], R)
    a = (a shr 1)
    b = (b shr 1)
  return self.f(L, R)

proc `[]`[T](self:SegmentTree[T],k:int):T = self.data[k + self.sz]

proc findSubtree[T](self:var SegmentTree[T], a:int, check:(T)->bool, M: var T, t:int):int =
  while a < self.sz:
    var nxt = if t == 1: self.f(self.data[2 * a + t], M) else: self.f(M, self.data[2 * a + t])
    if check(nxt): a = 2 * a + t
    else: M = nxt; a = 2 * a + 1 - t
  return a - self.sz

proc findFirst[T](self: SegmentTree[T], a:int, check:(T)->bool):int =
  var L = self.M1
  if a <= 0:
    if check(self.f(L, self.data[1])): return self.findSubtree(1, check, L, 0)
    return -1
  var b = self.sz
  a += self.sz
  b += self.sz
  while a < b:
    if (a and 1) != 0:
      let nxt = self.f(L, self.data[a])
      if check(nxt): return self.findSubtree(a, check, L, 0)
      L = nxt
      a += 1
    a = a shr 1;b = b shr 1
  return -1;

proc findLast[T](self: SegmentTree[T], b:int, check:(T)->bool):int =
  var R = self.M1
  if b >= self.sz:
    if check(self.f(self.data[1], R)): return self.findSubtree(1, check, R, 1)
    return -1
  var a = self.sz
  b += self.sz
  while a < b:
    if (b and 1) != 0:
      b -= 1
      let nxt = self.f(self.data[b], R)
      if check(nxt): return self.findSubtree(b, check, R, 1)
      R = nxt
    a = a shr 1;b = b shr 1
  return -1
#}}}

proc solve() =
  var st = initSegmentTree[int](N + 1, (a:int, b:int) => max(a, b), 0)
  ans := 0
  for i in 0..<N:
    var
      t = st.query(0..<h[i]) + a[i]
    ans.max=t
    st.update(h[i], t)
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  h = newSeqWith(N, nextInt())
  a = newSeqWith(N, nextInt())
  solve()
#}}}
