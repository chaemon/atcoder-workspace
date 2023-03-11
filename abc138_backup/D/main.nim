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


proc solve(N:int, Q:int, a:seq[int], b:seq[int], p:seq[int], x:seq[int]) =
  var
    G = newGraph[int](N)
    counter = newSeq[int](N)
    ans = newSeq[int](N)
  for i in 0..<N-1: G.addBiEdge(a[i],b[i])
  for i in 0..<Q: counter[p[i]] += x[i]
  proc dfs(u,p:int,val:var int) =
    val += counter[u]
    ans[u] = val
    for e in G[u]:
      if e.dst == p: continue
      dfs(e.dst,u,val)
    val -= counter[u]
  var val = 0
  dfs(0,-1,val)
  for a in ans:
    stdout.write(a," ")
  echo ""
  return 
proc main() =
  var N = 0
  N = nextInt()
  var Q = 0
  Q = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
    a[i].dec;b[i].dec
  var p = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    p[i] = nextInt()
    p[i].dec
    x[i] = nextInt()
  solve(N, Q, a, b, p, x);
  return

main()
