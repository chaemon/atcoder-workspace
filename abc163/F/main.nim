#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar, strformat
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

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for x in lens: a = fmt"makeSeq({x.repr}, {a})"
  parseStmt(a)

template makeArray(x; init):auto =
  when init is typedesc:
    var v:array[x, init]
  else:
    var v:array[x, init.type]
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for x in lens: a = fmt"makeArray({x.repr}, {a})"
  parseStmt(a)
#}}}

var N:int
var c:seq[int]
var a:seq[int]
var b:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  c = newSeqWith(N, nextInt() - 1)
  a = newSeqWith(N-1, 0)
  b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
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

# dump {{{
import macros

macro dump*(n: varargs[untyped]): untyped =
  var a = "stderr.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

cols := Seq(N, -1)
rest := Seq(N, int)
size := newSeq[int]()
ans := Seq(N, 0)

# tree dfs {{{
type TreeDFS[T] = object
  depth, parent, size, dist:seq[int]

proc initTreeDFS[T](g:Graph[T], r = 0):TreeDFS[T] =
  var depth = newSeqWith(g.len, 0)
  var parent = newSeqWith(g.len, 0)
  var size = newSeqWith(g.len, 0)
  var dist = newSeqWith(g.len, 0)

  proc dfs(idx, par, dep, d:int) =
    depth[idx] = d
    parent[idx] = par
    dist[idx] = d
    size[idx] = 1
    for e in g[idx]:
      if e.dst != par:
        dfs(e.dst, idx, dep + 1, d + e.weight)
        size[idx] += size[e.dst]
  dfs(r, -1, 0, 0)

  return TreeDFS[T](depth:depth, parent:parent, size:size, dist:dist)
# }}}

proc C2(n:int):int = n * (n + 1) div 2

# depth first search {{{
proc dfs[T](g:Graph[T], u:int, p = -1) =
  cols[c[u]] -= size[u]
  let old_cols = cols[c[u]]
  for e in g[u]:
    if e.dst == p: continue
    cols[c[u]] = size[e.dst]
    g.dfs(e.dst, u)
#    dump(u, c[u], cols[c[u]])
    ans[c[u]] += C2(cols[c[u]])
  cols[c[u]] = old_cols
#}}}

proc main() =
  if N == 1:
    echo 1;return
  colSet := c.toSet()
  for c in colSet:
    cols[c] = N
  g := initGraph[int](N)
  for i in 0..<N-1:
    g.addBiEdge(a[i], b[i])
  r := 0
  for u in 0..<N:
    if g[u].len == 1: r = u;break
  t := g.initTreeDFS(r)
  size = t.size
  g.dfs(r)
  for c in colSet:
#    dump(c, cols[c])
    ans[c] += C2(cols[c])
  for c in 0..<N:
    if c notin col_set:
      ans[c] = 0
    else:
      ans[c] = C2(N) - ans[c]
  for a in ans:
    print a
  return

main()
