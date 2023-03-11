# header {{{
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, strformat, sugar
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
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


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

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

var N:int
var Q:int
var c:seq[int]
var l:seq[int]
var r:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  Q = nextInt()
  c = newSeqWith(N, nextInt() - 1)
  l = newSeqWith(Q, 0)
  r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt() - 1
    r[i] = nextInt()
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
  var
    st = initDualSegmentTree[int](N + 1, (a:int,b:int)=>a+b, 0)
    nextCol = Seq(N, N)
    next = Seq(N, int)
    p = newSeq[tuple[l,r,i:int]]()
    ans = Seq(Q, int)
  for i in 0..<Q: p.add((l[i], r[i], i))
  p.sort()
  for i in countdown(N - 1, 0):
    next[i] = nextCol[c[i]]
    nextCol[c[i]] = i
  for c in 0..<N:
    if nextCol[c] != N:
      st.update(nextCol[c] + 1..N, 1)
  var j = 0
  for i0 in 0..<N:
    while j < Q and p[j].l == i0:
      ans[p[j].i] = st[p[j].r]
      j.inc
    var i1 = next[i0]
    st.update(i0..i1, -1)
  for a in ans:
    print a
  return

main()

