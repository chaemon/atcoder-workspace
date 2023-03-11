import sequtils, tables
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

#{{{ Graph
type Edge = object
  src,dst:int
  weight:int
  rev:int
  color:int

proc newEdge(src,dst,color,weight,rev:int):Edge =
  var e:Edge
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  e.color = color
  return e

type Graph = object
  adj:seq[seq[Edge]]

proc newGraph(n:int):Graph=
  var g:Graph
  g.adj = newSeqWith(n,newSeq[Edge]())
  return g

#proc addBiEdge(g:var Graph,src,dst:int,weight:int=1):void =
#  g.adj[src].add(newEdge(src,dst,weight,g.adj[dst].len))
#  g.adj[dst].add(newEdge(dst,src,weight,g.adj[src].len-1))
proc addBiEdge(g:var Graph,src,dst,color:int,weight:int=1):void =
  g.adj[src].add(newEdge(src,dst,color,weight,g.adj[dst].len))
  g.adj[dst].add(newEdge(dst,src,color,weight,g.adj[src].len-1))

proc addEdge(g:var Graph,src,dst,color:int,weight:int=1):void =
  g.adj[src].add(newEdge(src,dst,color,weight,-1))
#}}}

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

#{{{ offline common ancestor
type Query = object
  u,v,w:int

proc visit(g:Graph, u,w:int,qs: var seq[Table[int,int]], color:var seq[int],ancestor:var seq[int], uf:var UnionFind):void =
  ancestor[ uf.root(u) ] = u;
  for e in g.adj[u]:
    if e.dst != w:
      visit(g, e.dst, u, qs, color, ancestor, uf)
      uf.unionSet( e.src, e.dst )
      ancestor[ uf.root(u) ] = u
  color[u] = 1
  for w,t in qs[u].mpairs:
    if color[w] == 1:
      t = ancestor[uf.root(w)]

proc leastCommonAncestor(g:Graph, r:int, qs:var seq[Query]):void =
  let n = g.adj.len
  var
    qm = newSeqWith(n,initTable[int,int]())
    uf = newUnionFind(n)
    color = newSeq[int](n)
    ancestor = newSeq[int](n)
  for q in qs:
    qm[q.u][q.v] = -1
    qm[q.v][q.u] = -1

  visit(g, r, -1, qm, color, ancestor, uf)
  for q in qs.mitems:
    q.w = max(qm[q.u][q.v], qm[q.v][q.u]);
#}}}

var
  N = nextInt()
  Q = nextInt()
  a = newSeqWith(N-1,0)
  b = newSeqWith(N-1,0)
  c = newSeqWith(N-1,0)
  d = newSeqWith(N-1,0)
  x = newSeqWith(Q,0)
  y = newSeqWith(Q,0)
  u = newSeqWith(Q,0)
  v = newSeqWith(Q,0)
  g = newGraph(N)
  dists = newSeqWith(N,0)
  c_lists = newSeqWith(N,newSeq[int]())
  c_dists = newSeqWith(N,newTable[int,int]())
  c_nums = newSeqWith(N,newTable[int,int]())
  qs = newSeq[Query]()
for i in 0..N-2:
  a[i] = nextInt();b[i] = nextInt()
  c[i] = nextInt();d[i] = nextInt()
  a[i] -= 1;b[i] -= 1
  g.addBiEdge(a[i],b[i],c[i],d[i])
for i in 0..Q-1:
  x[i] = nextInt();y[i] = nextInt()
  u[i] = nextInt();v[i] = nextInt()
  u[i] -= 1; v[i] -= 1
  qs.add(Query(u:u[i],v:v[i]))

leastCommonAncestor(g,0,qs)

for j,q in qs:
  c_lists[q.u].add(x[j])
  c_lists[q.v].add(x[j])
  c_lists[q.w].add(x[j])

var
  c_num = newSeqWith(N,0)
  c_dist = newSeqWith(N,0)
  dist = 0

proc dfs(u:int = 0,p:int = -1):void =
  dists[u] = dist
  for c in c_lists[u]:
    c_nums[u][c] = c_num[c]
    c_dists[u][c] = c_dist[c]
  for e in g.adj[u]:
    if e.dst == p: continue
    dist += e.weight
    c_num[e.color] += 1
    c_dist[e.color] += e.weight
    dfs(e.dst,u)
    dist -= e.weight
    c_num[e.color] -= 1
    c_dist[e.color] -= e.weight

dfs()

for j,q in qs:
  var
    c = x[j]
    d = dists[q.u] + dists[q.v] - 2 * dists[q.w]
    cd = c_dists[q.u][c] + c_dists[q.v][c] - 2 * c_dists[q.w][c]
    cn = c_nums[q.u][c] + c_nums[q.v][c] - 2 * c_nums[q.w][c]
  echo d - cd + cn * y[j]
