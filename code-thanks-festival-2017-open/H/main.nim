import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

#{{{ Union-Find
type UnionFind = object
  data:seq[int]

proc newUnionFind(size:int):UnionFind =
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
  if rx != ry:
    if uf.data[ry] < uf.data[rx]:
      swap(rx, ry)
    uf.data[rx] += uf.data[ry]
    uf.data[ry] = rx
  return rx != ry;

proc findSet(uf:var UnionFind, x,y:int):bool =
  return uf.root(x) == uf.root(y)

#}}}

#{{{ Graph
type Edge = object
  src,dst:int
  weight:int
  rev:int

proc newEdge(src,dst,weight,rev:int):Edge =
  var e:Edge
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

type Graph = object
  adj:seq[seq[Edge]]

proc newGraph(n:int):Graph=
  var g:Graph
  g.adj = newSeqWith(n,newSeq[Edge]())
  return g

proc addBiEdge(g:var Graph,src,dst:int,weight:int=1):void =
  g.adj[src].add(newEdge(src,dst,weight,g.adj[dst].len))
  g.adj[dst].add(newEdge(dst,src,weight,g.adj[src].len-1))

proc addEdge(g:var Graph,src,dst:int,weight:int=1):void =
  g.adj[src].add(newEdge(src,dst,weight,-1))
#}}}

# leastCommonAncestor(Graph,root,seq[Query])
#{{{ offline common ancestor
type Query = object
  u,v,w:int

proc leastCommonAncestor(g:Graph, r:int, qs:var seq[Query]):void =
  let n = g.adj.len
  var
    qv = newSeqWith(n,newSeq[(int,int,int)]())
    uf = newUnionFind(n)
    color = newSeq[true](n)
    ancestor = newSeq[int](n)
  proc visit(u,prev:int):void =
    ancestor[ uf.root(u) ] = u;
    for e in g.adj[u]:
      if e.dst != prev:
        visit(e.dst, u)
        uf.unionSet( e.src, e.dst )
        ancestor[ uf.root(u) ] = u
    color[u] = true
    for (v,w,i) in qv[u].mitems:
      if color[v]:
        w = ancestor[uf.root(v)]
  for i,q in qs.mpairs:
    qv[q.u].add((q.v,-1,i))
    qv[q.v].add((q.u,-1,i))
    q.w = -1
  visit(r, -1)
  for qvu in qv:
    for (v,w,i) in qvu:
      qs[i].w = max(qs[i].w,w)
#}}}


proc main():void =
  var
    N = nextInt()
    M = nextInt()
    a = newSeq[int](M)
    b = newSeq[int](M)
    uf = newUnionFind(N)
    node = newSeq[int](N) # uf node -> tree node
    time = newSeq[int](N)
    parent = newSeqWith(N,-1)
  
  for u in 0..<N:
    node[u] = u
  for t in 0..<M:
    a[t] = nextInt()
    b[t] = nextInt()
    a[t] -= 1
    b[t] -= 1
    var
      node_ar = node[uf.root(a[t])]
      node_br = node[uf.root(b[t])]
    uf.unionSet(a[t],b[t])
    var
      r = uf.root(a[t])
    node[r] = time.len
    parent.add(-1)
    time.add(t)
    parent[node_ar] = node[r]
    parent[node_br] = node[r]
  var
    Q = nextInt()
    G = newGraph(len(parent)+1)
    ans = newSeqWith(Q,-1)
    x = newSeq[int](Q)
    y = newSeq[int](Q)
    rt = len(parent)
  for u,p in parent.mpairs:
    if p == -1:
      p = rt
    G.addBiEdge(u,p)

  var
    qs = newSeq[Query]()
  for q in 0..<Q:
    x[q] = nextInt()
    y[q] = nextInt()
    x[q] -= 1
    y[q] -= 1
    qs.add(Query(u:x[q],v:y[q]))
  leastCommonAncestor(G,rt,qs)
  for q in 0..<Q:
    var
      r = qs[q].w
    if r == rt:
      echo -1
    else:
      echo time[r] + 1

main()
