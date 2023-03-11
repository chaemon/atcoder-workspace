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

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var Q:int
var xmin:seq[int]
var ymin:seq[int]
var D:seq[int]
var C:seq[int]
var A:seq[int]
var B:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  Q = nextInt()
  xmin = newSeqWith(N, 0)
  ymin = newSeqWith(N, 0)
  D = newSeqWith(N, 0)
  C = newSeqWith(N, 0)
  for i in 0..<N:
    xmin[i] = nextInt()
    ymin[i] = nextInt()
    D[i] = nextInt()
    C[i] = nextInt()
  A = newSeqWith(Q, 0)
  B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
#}}}

# DualSegmentTree {{{
type DualSegmentTree[L] = object
  sz, height: int
  lazy: seq[L]
  h: (L, L) -> L
  L0: L

proc initDualSegmentTree[L](n:int, h:(L,L)->L, L0:L):DualSegmentTree[L] =
  var
    sz = 1
    height = 0
  while sz < n: sz *= 2;height+=1
  return DualSegmentTree[L](sz:sz, height:height, lazy:newSeqWith(2*sz, L0), h:h, L0:L0)

proc propagate[L](self: var DualSegmentTree[L], k:int) =
  if self.lazy[k] != self.L0:
    self.lazy[2 * k + 0] = self.h(self.lazy[2 * k + 0], self.lazy[k])
    self.lazy[2 * k + 1] = self.h(self.lazy[2 * k + 1], self.lazy[k])
    self.lazy[k] = self.L0

proc thrust[L](self: var DualSegmentTree[L], k:int) =
  for i in countdown(self.height,1): self.propagate(k shr i)

proc update[L](self: var DualSegmentTree[L], p:Slice[int], x:L) =
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

proc `[]`[L](self:var DualSegmentTree[L], k:int):L =
  var k = k + self.sz
  self.thrust(k)
  return self.lazy[k]
# }}}

proc main() =
  xa := newSeq[int]()
  ya := newSeq[int]()
  qr_open := newSeq[(int,int,int,int)]() # x, y0, y1, cost
  qr_close := newSeq[(int,int,int,int)]() # x, y0, y1, cost
  qs := newSeq[(int,int,int)]()
  for i in 0..<N:
    xa.add(xmin[i])
    xa.add(xmin[i] + D[i])
    ya.add(ymin[i])
    ya.add(ymin[i] + D[i])
  for q in 0..<Q:
    xa.add(A[q])
    ya.add(B[q])
  xa = xa.toSet().mapIt(it)
  ya = ya.toSet().mapIt(it)
  xa.sort()
  ya.sort()
  for i in 0..<N:
    let
      x0 = xa.lowerBound(xmin[i])
      x1 = xa.lowerBound(xmin[i] + D[i])
      y0 = ya.lowerBound(ymin[i])
      y1 = ya.lowerBound(ymin[i] + D[i])
    qr_open.add((x0, y0, y1, C[i]))
    qr_close.add((x1, y0, y1, C[i]))
  qr_open.sort()
  qr_close.sort()
  var st = initDualSegmentTree[int](ya.len, (a:int,b:int)=>a+b, 0)
  for q in 0..<Q:
    let (a, b) = (xa.lowerBound(A[q]), ya.lowerBound(B[q]))
    qs.add((a, b, q))
  qs.sort()
  var ans = newSeq[int](Q)
  var io, ic = 0
  for (a,b,q) in qs:
    while io < qr_open.len and qr_open[io][0] <= a:
      let (x, y0, y1, cost) = qr_open[io]
      st.update(y0..y1, cost)
      io.inc
    while ic < qr_close.len and qr_close[ic][0] < a:
      let (x, y0, y1, cost) = qr_close[ic]
      st.update(y0..y1, -cost)
      ic.inc
    ans[q] = st[b]
  for ans in ans:
    print ans
  return

main()
