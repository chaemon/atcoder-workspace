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
var M:int
var A:seq[int]
var B:seq[int]
var C:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(M, 0)
  B = newSeqWith(M, 0)
  C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
#}}}

# Graph {{{
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]
  Matrix[T] = seq[seq[T]]

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
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], T(1))
proc initGraph[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[int]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], T(1))


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

#{{{ Union-Find
type UnionFind = object
  data:seq[int]

proc initUnionFind(size:int):UnionFind =
  var uf:UnionFind
  uf.data = newSeqWith(size,-1)
  return uf

proc compress(uf:var UnionFind,x:int,r:var int):void =
  if uf.data[x]<0:
    r = x
    return
  uf.compress(uf.data[x],r)
  uf.data[x] = r;

proc root(uf:var UnionFind, x:int):int =
  var r:int
  uf.compress(x,r)
  return r;

proc size(uf:var UnionFind, x:int):int =
  return -uf.data[uf.root(x)]

proc unionSet(uf:var UnionFind, x,y:int):bool{.discardable.} =
  var
    rx = uf.root(x)
    ry = uf.root(y)
  if rx == ry: return false
  if uf.data[ry] < uf.data[rx]:
    swap(rx, ry)
  uf.data[rx] += uf.data[ry]
  uf.data[ry] = rx
  return true

proc findSet(uf:var UnionFind, x,y:int):bool =
  return uf.root(x) != uf.root(y)
#}}}

var qs = newSeq[HashSet[int]](N)
var ans = newSeq[int](M)

# {{{ Kruskal
proc kruskal[T](g:Graph[T]):(T, seq[Edge[T]]) =
  var es = newSeq[Edge[T]]()
  for u in 0..<g.len:
    for e in g[u]:
      es.add(e)
  es.sort()
  var
    ret = newSeq[Edge[T]]()
    tree = initUnionFind(g.len)
    total = T(0)
  for e in es:
    var
      f = tree.root(e.src)
      t = tree.root(e.dst)
    if tree.unionSet(e.src, e.dst):
      total += e.weight
      ret.add(e)
      let r = tree.root(e.src)
      if qs[f].len < qs[t].len:
        swap(qs[f], qs[t])
      for p in qs[t]:
        if p in qs[f]:
          ans[p] = e.weight
          qs[f].excl(p)
        else:
          qs[f].incl(p)
      swap(qs[r], qs[f])
  return (total, ret)
# }}}

proc main() =
  g := initGraph[int](N)
  for i in 0..<M:
    g.addBiEdge(A[i], B[i], C[i])
    qs[A[i]].incl(i)
    qs[B[i]].incl(i)
  let (m, es) = g.kruskal()
  for i in 0..<M:
    ans[i] = m - ans[i] + C[i]
  for ans in ans:
    echo ans
  return

main()
