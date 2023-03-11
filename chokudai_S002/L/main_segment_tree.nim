#{{{ header
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
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ segment tree
import future

type SegmentTree[T] = object
  sz:int
  data:seq[T]
  M1:T
  f:(T,T)->T

proc newSegmentTree[T](n:int,f:(T,T)->T,M1:T):SegmentTree[T] =
  var sz = 1
  while sz < n: sz *= 2
  return SegmentTree[T](sz:sz,data:newSeq[T](sz*2),M1:M1,f:f)

proc set[T](self:var SegmentTree[T], k:int, x:T) =
  self.data[k + self.sz] = x

proc build[T](self:var SegmentTree[T]) =
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
  return self.f(L, R);

proc `[]`[T](self:SegmentTree[T],k:int):T = self.data[k + self.sz]
#}}}

proc main():void =
  let N = nextInt()
  var
    p = newSeq[(int,int)]()
    A = newSeq[int](N)
    B = newSeq[int](N)
    v = newSeq[int]()
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    if A[i] > B[i]: swap(A[i],B[i])
    p.add((A[i],B[i]))
  p.sort(cmp[(int,int)])
  for i in 0..<N:A[i] = p[i][0];B[i] = p[i][1]
  for i in 0..<N:
    v.add(B[i])
  v.sort(cmp[int])
  v = v.deduplicate()
  for i in 0..<N:
    B[i] = binarySearch(v,B[i])
  var st = newSegmentTree[int](v.len + 5,(A:int,B:int)=>max(A,B),0)
  var i = 0
  while i < N:
    var j = i
    while j < N and A[j] == A[i]: j += 1
    var a = newSeq[int]()
    for k in i..<j: a.add(st.query(0,B[k]))
    for k in i..<j: st.update(B[k],a[k - i] + 1)
    i = j
  echo st.query(0,v.len+1)
  discard

main()

