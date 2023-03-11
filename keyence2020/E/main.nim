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

#{{{ Graph
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev,id:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]

proc initEdge[T](src,dst:int,weight:T,rev = -1, id = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  e.id = id
  return e

proc initGraph[T](n:int):Graph[T] =
  return newSeqWith(n,newSeq[Edge[T]]())

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight = T(1),id = -1):void =
  g[src].add(initEdge(src,dst,weight,g[dst].len, id))
  g[dst].add(initEdge(dst,src,weight,g[src].len-1, id))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(initEdge(src,dst,weight,-1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

var N:int
var M:int
var D:seq[int]
var U:seq[int]
var V:seq[int]

proc solve() =
  g := initGraph[int](N)
  for i in 0..<M:
    g.addBiEdge(U[i], V[i], id = i)
  p := newSeq[(int,int)]()
  for u in 0..<N:
    p.add((D[u], u))
  p.sort()
  i := 0
  vis := newSeqWith(N, false)
  color := newSeqWith(N, -1)
  w := newSeqWith(M, 10^9)
  proc dfs(u, p, depth, weight, id:int) =
    color[u] = depth mod 2
    vis[u] = true
    if id != -1:
      w[id] = weight
    for e in g[u]:
      if e.dst == p or vis[e.dst] or D[e.dst] != weight: continue
      dfs(e.dst, u, depth + 1, weight, e.id)
  while i < N:
    j := i
    cur_dist := p[i][0]
    while j < N and p[j][0] == cur_dist: j += 1
    not_found := initSet[int]()
    for k in i..<j:
      u := p[k][1]
      found := false
      ct := 0
      for e in g[u]:
        if D[e.dst] == D[u]: ct += 1
        if vis[e.dst]:
          color[u] = color[e.dst]
          w[e.id] = D[u] - D[e.dst]
#          color[u] = 1 - color[e.dst]
#          w[e.id] = D[u]
          found = true
          break
      if not found:
        if ct == 0:
          echo -1;return
        not_found.incl(u)
    for u in not_found:
      if vis[u]: continue
      dfs(u, -1, 0, cur_dist, -1)
    for k in i..<j:
      u := p[k][1]
      vis[u] = true
    i = j
  echo color.mapIt(if it == 0: "B" else: "W").join()
  for wi in w:
    echo wi
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  D = newSeqWith(N, nextInt())
  U = newSeqWith(M, 0)
  V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve()
#}}}
