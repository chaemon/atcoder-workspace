#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
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

#{{{ Graph
type Edge[T] = object
  src,dst:int
  weight:T
  rev:int

proc newEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

type Graph[T] = seq[seq[Edge[T]]]

proc newGraph[T](n:int):Graph[T]=
  var g:Graph[T]
  g = newSeqWith(n,newSeq[Edge[T]]())
  return g

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

proc topologicalSort[T](g:Graph[T]):(bool,seq[int]) =
  let n = g.len
  var
    color = newSeq[int](n)
    order = newSeq[int](n)

  proc visit(v:int): bool =
    color[v] = 1
    for e in g[v]:
      if color[e.dst] == 2: continue
      if color[e.dst] == 1: return false
      if not visit(e.dst): return false
    order.add(v); color[v] = 2
    return true

  for u in 0..<n:
    if color[u] == 0 and not visit(u): return (false,order)
  order.reverse
  return (true,order)


proc id(a,b:int):int =
  var
    a = a
    b = b
  assert(a != b)
  if a < b: swap(a,b)
  return a * (a - 1) div 2  + b

proc solve(N:int, A:seq[seq[int]]) =
  var G = newGraph[int](N*(N+1) div 2 + 2)
  let
    s = G.len - 2
    t = G.len - 1
  for u in 0..<N:
    G.addEdge(s,id(u,A[u][0]))
    for i in 0..<N-2:
      let
        c0 = id(u,A[u][i])
        c1 = id(u,A[u][i+1])
      G.addEdge(c0,c1)
    G.addEdge(id(u,A[u][N-2]),t)
  let (r,order) = G.topologicalSort()
  if not r:
    echo -1
    return
  var dp = newSeq[int](G.len)
  dp[0] = 0
  for u in order:
    if u == s or u == t: continue
    for e in G[u]:
      dp[e.dst].max=(dp[u] + 1)
  echo dp[t]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, newSeqWith(N-1, 0))
  for i in 0..<N:
    for j in 0..<N-1:
      A[i][j] = nextInt().pred
  solve(N, A);
  return

main()
#}}}
