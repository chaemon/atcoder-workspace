#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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
  return SegmentTree[T](sz:sz,data:newSeq[T](sz*2),M1:M1)

proc set[T](self:var SegmentTree[T], k:int, x:T) =
  self.data[k + self.sz] = x

proc build[T](self:var SegmentTree[T]) =
  for k in countdown(self.sz-1,1):
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1]);
proc update[T](self:var SegmentTree[T], k:int, x:T) =
  var k = k + self.sz
  self.data[k] = x
  while k > 0:
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1])
    k = (k shr 2)

proc query[T](self:SegmentTree[T],a,b:int):T =
  var
    L = self.M1
    R = self.M1
    a = a + self.sz
    b = b + self.sz
  while a < b:
    if a mod 2 == 1: L = self.f(L, self.data[a]);a += 1
    if b mod 2 == 1: b -= 1;R = self.f(self.data[b], R)
    a = (a shr 1)
    b = (b shr 1)
  return self.f(L, R);
#}}}

proc fun(x,y:int):int = max(x,y)
proc solve(N:int, P:seq[int]) =
  var st = newSegmentTree[int](N,fun,int.infty)
  for i in 0..<N: st.set(i,P[i])
  st.build()
  proc findLeftMax(i:int):(int,int) =
    result = (-1,-1)
    let t = st.query(0,i+1)
    if t == P[i]: return
    block:
      var
        l = 0
        r = i
      while r - l > 1:
        let m = (l + r) div 2
        if st.query(m,i+1) > P[i]: l = m
        else: r = m
      result[1] = l
      if t == P[l]: return
    var
      l = 0
      r = result[1]
    while r - l > 1:
      let m = (l + r) div 2
      if st.query(m,i+1) > P[i]: l = m
      else: r = m
    result[0] = l
    return
  proc findRightMax(i:int):(int,int) =
    result = (N,N)
    let t = st.query(i+1,N)
    if t == P[i]: return
    block:
      var
        l = i+1
        r = N
      while r - l > 1:
        let m = (l + r) div 2
        if st.query(i+1,m+1) > P[i]: r = m
        else: l = m
      result[0] = r
      if t == P[r]: return
    var
      l = result[0] + 1
      r = N
    while r - l > 1:
      let m = (l + r) div 2
      if st.query(i+1,m+1) > P[i]: r = m
      else: l = m
    result[1] = r
    return
  for i in 0..<N:
    let
      left = findLeftMax(i)
      right = findRightMax(i)
    echo i
    echo left,right
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
  solve(N, P);
  return

main()
#}}}
