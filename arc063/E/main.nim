#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
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

proc `$`(n:int):string =
  if n >= int.inf: "inf" elif n <= -int.inf: "-inf" else: system.`$`(n)

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

const YES = "Yes"
const NO = "No"
var N:int
var A:seq[int]
var B:seq[int]
var K:int
var V:seq[int]
var P:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N-1, 0)
  B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  K = nextInt()
  V = newSeqWith(K, 0)
  P = newSeqWith(K, 0)
  for i in 0..<K:
    V[i] = nextInt() - 1
    P[i] = nextInt()
#}}}

#{{{ Graph
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]

proc initEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

proc initGraph[T](n:int):Graph[T] =
  return newSeqWith(n,newSeq[Edge[T]]())

proc addBiEdge[T](g:var Graph[T],e:Edge[T]):void =
  var e_rev = e
  swap(e_rev.src, e_rev.dst)
  let (r, s) = (g[e.src].len, g[e.dst].len)
  g[e.src].add(e)
  g[e.dst].add(e_rev)
  g[e.src][^1].rev = s
  g[e.dst][^1].rev = r
proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addBiEdge(initEdge(src, dst, weight))

proc initUndirectedGraph[T](n:int, a,b,c:seq[T]):Graph[T] =
  var result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], T(1))
proc initGraph[T](n:int, a,b,c:seq[T]):Graph[T] =
  var result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], T(1))


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

#ReRooting: initReRooting[Weight, Data](n:int, f_up(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data)
# {{{
import sequtils, future
type
  Node[Weight] = object
    to, rev: int
    data: Weight
  ReRooting[Weight, Data] = object
    g:seq[seq[Node[Weight]]]
    ldp, rdp: seq[seq[Data]]
    lptr, rptr: seq[int]
    ident: Data
    f_up: (Data,Weight)->Data
    f_merge: (Data,Data)->Data

proc initNode[Weight](to, rev:int, d: Weight):Node[Weight] = Node[Weight](to: to, rev: rev, data: d)
proc initReRooting[Weight, Data](n:int, f_up:(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data):ReRooting[Weight,Data] =
  return ReRooting[Weight,Data](
    g:newSeqWith(n, newSeq[Node[Weight]]()),
    ldp:newSeqWith(n, newSeq[Data]()),
    rdp:newSeqWith(n, newSeq[Data]()),
    lptr:newSeq[int](n), rptr:newSeq[int](n),
    f_up:f_up, f_merge:f_merge, ident:ident)

proc addEdge[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, d))
proc addEdgeBi[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d,e:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, e))
proc dfs[Weight, Data](self: var ReRooting[Weight, Data], idx, par:int):Data =
  while self.lptr[idx] != par and self.lptr[idx] < self.g[idx].len:
    var e = self.g[idx][self.lptr[idx]].addr
    self.ldp[idx][self.lptr[idx] + 1] = self.f_merge(self.ldp[idx][self.lptr[idx]], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.lptr[idx] += 1
  while self.rptr[idx] != par and self.rptr[idx] >= 0:
    var e = self.g[idx][self.rptr[idx]].addr
    self.rdp[idx][self.rptr[idx]] = self.f_merge(self.rdp[idx][self.rptr[idx] + 1], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.rptr[idx] -= 1
  if par < 0: return self.rdp[idx][0]
  result = self.f_merge(self.ldp[idx][par], self.rdp[idx][par + 1])
#  echo "ReRooting DFS: ", idx, " ", par, " ", result

proc solve[Weight, Data](self: var ReRooting[Weight, Data]):seq[Data] =
  for i in 0..<self.g.len:
    self.ldp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.rdp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.lptr[i] = 0
    self.rptr[i] = self.g[i].len - 1
  result = newSeq[Data]()
  for i in 0..<self.g.len: result.add(self.dfs(i, -1))
#}}}

#{{{ Slice
proc len[T](self: Slice[T]):int = (if self.a > self.b: 0 else: self.b - self.a + 1)
proc empty[T](self: Slice[T]):bool = self.len == 0

proc `<`[T](p, q: Slice[T]):bool = return if p.a < q.a: true elif p.a > q.a: false else: p.b < q.b
proc intersection[T](p, q: Slice[T]):Slice[T] = max(p.a, q.a)..min(p.b, q.b)
proc union[T](v: seq[Slice[T]]):seq[Slice[T]] =
  var v = v
  v.sort(cmp[Slice[T]])
  result = newSeq[Slice[T]]()
  var cur = -T.inf .. -T.inf
  for p in v:
    if p.empty: continue
    if cur.b + 1 < p.a:
      if cur.b != -T.inf: result.add(cur)
      cur = p
    elif cur.b < p.b: cur.b = p.b
  if cur.b != -T.inf: result.add(cur)
proc `in`[T](s:Slice[T], x:T):bool = s.contains(x)
proc `*`[T](p, q: Slice[T]):Slice[T] = intersection(p,q)
proc `+`[T](p, q: Slice[T]):seq[Slice[T]] = union(@[p,q])
#}}}

var val = newSeqWith(N, -1)

proc f_up(d:Slice[int], w:int):Slice[int] =
  if val[w] != -1:
#    echo "found: ", w, " ", val[w]
    return val[w] - 1..val[w] + 1
  else:
    return d.a - 1..d.b + 1
proc f_merge(a,b:Slice[int]):Slice[int] =
  result = intersection(a,b)
#  echo "merge: ", a, b, result

var color = newSeq[int](N)

# depth first search {{{
proc dfs[T](g:Graph[T], u:int, p = -1, col = 0) =
  color[u] = col
  for e in g[u]:
    if e.dst == p: continue
    g.dfs(e.dst, u, 1 - col)
#}}}

var dp = newSeq[Slice[int]]()
var ans = newSeq[int](N)

proc dfs2[T](g:Graph[T], u:int, p = -1, pv = int.inf):bool =
  var v:int
  if val[u] != -1:
    v = val[u]
    if p != -1 and abs(pv - v) != 1: return false
  elif p == -1:
    v = dp[u].a
    if v mod 2 != color[u]: v += 1
    if v notin dp[u]: return false
  else:
    var found = false
    for t in [pv - 1, pv + 1]:
      if t in dp[u]: v = t;found = true
    if not found: return false
  ans[u] = v
  for e in g[u]:
    if e.dst == p: continue
    if not g.dfs2(e.dst, u, v): return false
  return true



proc main() =
  var g = initUndirectedGraph(N, A, B)
  g.dfs(0)
  var d = -1
  for i in 0..<K:
    val[V[i]] = P[i]
    let e = (color[V[i]] + P[i]) mod 2
    if d == -1:
      d = e
    elif d != e:
      echo NO;return
  for u in 0..<N:
    color[u] += d
    color[u] = color[u] mod 2
  var rr = initReRooting[int, Slice[int]](N, f_up, f_merge, -int.inf..int.inf)
  for i in 0..<N-1:rr.addEdgeBi(A[i], B[i], B[i], A[i])
  dp = rr.solve()
  if not g.dfs2(0):
    echo NO;return
  echo YES
  for ans in ans:
    echo ans
  return

main()
