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

#{{{ Graph
type Edge[T] = object
  src,dst:int
  weight:T
  rev:int

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight

proc newEdge[T](src,dst:int,weight:T,rev:int):Edge[T] =
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

#{{{ bellman-ford shortest path
proc shortestPath[T](g:Graph[T], s:int): (bool,seq[T],seq[int]) =
  let n = g.len
  var
    dist = newSeqWith(n,T.infty)
    prev = newSeqWith(n,-2)
    negative_cycle = false
  dist[s] = 0
  for k in 0..<n:
    for u in 0..<n:
      if dist[u] == T.infty: continue
      for e in g[u]:
        let t = dist[e.src] + e.weight
        if dist[e.dst] > t:
          dist[e.dst] = t
          prev[e.dst] = e.src
          if k == n-1:
            dist[e.dst] = -T.infty
            negative_cycle = true
  if negative_cycle:
    for k in 0..<n:
      for u in 0..<n:
        if dist[u] != -T.infty: continue
        for e in g[u]:
          dist[e.dst] = -T.infty
  return (not negative_cycle, dist, prev)
#}}}



proc buildPath(prev:seq[int], t:int):seq[int] =
  result = newSeq[int]()
  var
    u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()

proc solve(N:int, M:int, P:int, A:seq[int], B:seq[int], C:seq[int]) =
  var G = newGraph[int](N)
  for i in 0..<M: G.addEdge(A[i],B[i],P - C[i])
  let (r,dist,_) = shortestPath(G,0)
  if dist[N-1] == -int.infty:
    echo -1
  else:
    echo max(0,-dist[N-1])
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var P = 0
  P = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    A[i].dec;B[i].dec
  solve(N, M, P, A, B, C);
  return

main()
