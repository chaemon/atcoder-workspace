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

let N,Q = nextInt()

proc centroidDecomposition(g:Graph[int],root=0):void =
  let n = g.len
  var
    sub = newSeqWith(n,0)
    belong = newSeqWith(n,newSeqWith(0,0))
    v = newSeqWith(n,false)
    c = root
  proc build_dfs(idx,par:int):int =
    sub[idx] = 1
    for e in g[idx]:
      if e.dst == par or v[e.dst]: continue
      sub[idx] += build_dfs(e.dst, idx)
    return sub[idx]

  proc search_centroid(idx,par,mid:int):int =
    for e in g[idx]:
      if e.dst == par or v[e.dst]: continue
      if sub[e.dst] > mid: return search_centroid(e.dst,idx,mid)
    return idx

  proc belong_dfs(idx,par,centroid:int) =
    belong[idx].add(centroid)
    for e in g[idx]:
      if e.dst == par or v[e.dst]: continue
      belong_dfs(e.dst,idx,centroid)

  while true:
    let centroid = search_centroid(c, -1, build_dfs(c, -1) div 2)
    v[centroid] = true
#    belong_dfs(centroid, -1, centroid)
    var adj = newSeq[(int,int)]() # size, node
    for e in g[centroid]:
      if not v[e.dst]:
        adj.add((build_dfs(e.dst,-1),e.dst))
#        t.addEdge(centroid,build(t, e.dst),sub[e.dst])
    adj.sort(cmp[(int,int)])
    adj.reverse()
    if adj.len == 0:
      echo("! ",c+1)
      return
    elif adj.len == 1:# only one edge
      echo("? ",c+1," ",adj[0][1]+1)
      let ans = nextInt()
      echo("! ",ans)
      return
    else:
      let
        u0 = adj[0][1]
        u1 = adj[1][1]
      echo("? ",u0+1," ",u1+1)
      var r = nextInt()
#      stderr.write("get: ",r,"\n")
      if r == 0:
        v[u0] = true
        v[u1] = true
        v[centroid] = false
        c = centroid
      else:
        r -= 1
        for p in adj:
          let u = p[1]
          if u != r: v[u] = true
        c = r

proc main():void =
  var g = newGraph[int](N)
  for i in 0..<N-1:
    let a,b = nextInt() - 1
    g.addBiEdge(a,b)
  centroidDecomposition(g,4)
  discard

main()

