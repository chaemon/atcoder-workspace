#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

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

#{{{ segment tree
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
#  self.data[k] = x
  self.data[k] = self.f(self.data[k], x)
  while true:
    k = (k shr 1)
    if k == 0: break
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1])

proc query[T](self:SegmentTree[T],a,b:int):T =
  var
    (L,R) = (self.M1, self.M1)
    (a,b) = (a + self.sz, b + self.sz)
  while a < b:
    if a mod 2 == 1: L = self.f(L, self.data[a]);a += 1
    if b mod 2 == 1: b -= 1;R = self.f(self.data[b], R)
    a = (a shr 1)
    b = (b shr 1)
  return self.f(L, R)

proc `[]`[T](self:SegmentTree[T],k:int):T = self.data[k + self.sz]

proc findSubtree[T](self:SegmentTree[T], a:int, check:(T)->bool, M: var T, t:int):int =
  var a = a
  while a < self.sz:
    var nxt = if t == 1: self.f(self.data[2 * a + t], M) else: self.f(M, self.data[2 * a + t])
    if check(nxt): a = 2 * a + t
    else: M = nxt; a = 2 * a + 1 - t
  return a - self.sz

proc findFirst[T](self: SegmentTree[T], a:int, check:(T)->bool):int =
  var L = self.M1
  var a = a
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

proc `[]`[A, B](t: var Table[A, B], key: A): var B =
  discard t.hasKeyOrPut(key, cast[A](0))
  tables.`[]`(t, key)
#}}}

#{{{ findFirst, findLast
proc findFirst(f:(int)->bool, l, r:int):int =
  var (l, r) = (l, r)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, l, r:int):int =
  var (l, r) = (l, r)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l

proc findFirst(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  if not f(l): return -float(Inf)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): l = m
    else: r = m
  return l
#}}}


proc solve(N:int, a:seq[int]) =
  var v = a.sorted(cmp[int])
  let M = N * (N + 1) div 4
  proc f(i:int):bool =
    var
      s = 0
      ans = 0
      st = initSegmentTree[int](N*2+10, (a:int, b:int)=>a+b, 0)
    st.update(s+N, 1)
    for j in 0..<N:
      if v[i] <= a[j]: s += 1
      else: s -= 1
      ans += st.query(s+N+1, st.sz)
      st.update(s+N, 1)
    if ans >= M + 1: return false
    else: return true
  let t = findLast(f, 0, N)
  echo v[t]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, a);
  return

main()
#}}}
