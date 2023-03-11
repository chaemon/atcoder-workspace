#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

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

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")
#}}}

var N:int
var A:seq[int]
var B:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt() - 1)
  B = newSeqWith(N, nextInt() - 1)
#}}}

#{{{ SegmentTree: initSegmentTree[D](n:int, f:(D,D)->D, D0:D)
type SegmentTree[D] = object
  sz:int
  data:seq[D]
  D0:D
  f:(D,D)->D

proc initSegmentTree[D](n:int,f:(D,D)->D,D0:D):SegmentTree[D] =
  var sz = 1
  while sz < n: sz *= 2
  return SegmentTree[D](sz:sz,data:newSeqWith(sz*2,D0),D0:D0,f:f)

# preset and build {{{
proc preset[D](self:var SegmentTree[D], k:int, x:D) =
  self.data[k + self.sz] = x

proc build[D](self:var SegmentTree[D]) =
  for k in countdown(self.sz-1,1):
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1]);

proc build[D](self:var SegmentTree[D], v:seq[D]) =
  for i in 0..<self.sz:
    self.data[i + self.sz] = if i < v.len: v[i] else: self.D0
  self.build()
# }}}

# recalc, update, [], []= {{{
proc recalc[D](self: var SegmentTree[D], k:int) =
  var k = k
  while true:
    k = (k shr 1)
    if k == 0: break
    self.data[k] = self.f(self.data[2 * k + 0], self.data[2 * k + 1])

proc update[D](self:var SegmentTree[D], k:int, x:D) =
  var k = k + self.sz
  self.data[k] = self.f(self.data[k], x)
  self.recalc(k)

proc `[]=`[D](self:var SegmentTree[D], k:int, x:D) =
  var k = k + self.sz
  self.data[k] = x
  self.recalc(k)

proc `[]`[D](self:SegmentTree[D],p:Slice[int]):D =
  var
    (L,R) = (self.D0, self.D0)
    (a,b) = (p.a + self.sz, p.b + 1 + self.sz)
  while a < b:
    if a mod 2 == 1: L = self.f(L, self.data[a]);a += 1
    if b mod 2 == 1: b -= 1;R = self.f(self.data[b], R)
    a = (a shr 1)
    b = (b shr 1)
  return self.f(L, R)

proc `[]`[D](self:SegmentTree[D],k:int):D = self.data[k + self.sz]
# }}}

# findFirst and findLast {{{
proc findSubtree[D](self:SegmentTree[D], a:int, check:(D)->bool, M: var D, t:int):int =
  var a = a
  while a < self.sz:
    var nxt = if t == 1: self.f(self.data[2 * a + t], M) else: self.f(M, self.data[2 * a + t])
    if check(nxt): a = 2 * a + t
    else: M = nxt; a = 2 * a + 1 - t
  return a - self.sz

# minimal x for which [a, x) is true (FFFFFFTTTTTT)
proc findFirst[D](self: SegmentTree[D], a:int, check:(D)->bool):int =
  var L = self.D0
  if a <= 0:
    if check(self.f(L, self.data[1])): return self.findSubtree(1, check, L, 0)
    return -1
  var a = a + self.sz
  var b = self.sz + self.sz
  while a < b:
    if (a and 1) > 0:
      let nxt = self.f(L, self.data[a])
      if check(nxt): return self.findSubtree(a, check, L, 0)
      L = nxt
      a += 1
    a = a shr 1;b = b shr 1
  return -1;

# minimal x for which [x, b) is true  (TTTTTTFFFFFFF)
proc findLast[D](self: SegmentTree[D], b:int, check:(D)->bool):int =
  var R = self.D0
  if b >= self.sz:
    if check(self.f(self.data[1], R)): return self.findSubtree(1, check, R, 1)
    return -1
  var a = 0 + self.sz
  var b = b + self.sz
  while a < b:
    if (b and 1) > 0:
      b -= 1
      let nxt = self.f(self.data[b], R)
      if check(nxt): return self.findSubtree(b, check, R, 1)
      R = nxt
    a = a shr 1;b = b shr 1
  return -1
#}}}
#}}}

proc dist(A, B:seq[int]):int =
  var A = A
  let N = A.len
  a := newSeq[int](N)
  for i in 0..<N: a[B[i]] = i
  for i in 0..<N: A[i] = a[A[i]]
  result = 0
  for i in 0..<N:
    for j in i+1..<N:
      if A[i] > A[j]: result += 1

proc main() =
  var a = newSeq[int](N)
  var pos = newSeq[int](N)
  var A2 = newSeq[int](N)
  for i in 0..<N:
    a[B[i]] = i
  for i in 0..<N: A2[i] = a[A[i]]
#  for i in 0..<N: B[i] = a[B[i]]
  for i in 0..<N: pos[A2[i]] = i
  st := initSegmentTree[int](N, proc(a,b:int):auto = a + b, 0)
  for i in 0..<N: st.update(i, 1)
#  echo A
  s := 0
  for i in 0..<N:
    let d = st[0..<pos[i]]
    s += d
#    dump(d)
    st.update(pos[i], -1)
  if s mod 2 == 1:
    echo -1;return
  s = s div 2
  st2 := initSegmentTree[int](N, proc(a,b:int):auto = a + b, 0)
  for i in 0..<N: st.update(i, 1)
  ans := newSeq[int]()
  for i in 0..<N:
    let d = st[0..<pos[i]]
    st.update(pos[i], -1)
    if d <= s:
      s -= d
      ans.add(i)
    else:
      var
        pi:int
        v = newSeq[int]()
      for a in A2:
        if a == i: pi = v.len
        if a >= i: v.add(a)
      assert(v[pi] == i)
      for _ in 0..<s:
        swap(v[pi], v[pi - 1])
        pi -= 1
      ans = ans & v
      for a in ans.mitems:
        a = B[a]
      break
#  echo dist(A, ans)
#  echo dist(B, ans)
  for a in ans.mitems:
    a += 1
  print ans
  return

main()
