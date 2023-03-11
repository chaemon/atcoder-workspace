#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
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
  id:int

proc newEdge[T](src,dst:int,weight:T,rev:int = -1,id:int):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  e.id = id
  return e

type Graph[T] = seq[seq[Edge[T]]]

proc newGraph[T](n:int):Graph[T]=
  var g:Graph[T]
  g = newSeqWith(n,newSeq[Edge[T]]())
  return g

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1,id:int):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len,id))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1,id))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

proc solve(N:int, a:seq[int], b:seq[int], s:seq[int]) =
  var
    G = newGraph[int](N)
    ans = newSeqWith(N-1,-1)
    pending = -1
  for i in 0..<a.len: G.addBiEdge(a[i],b[i],1,i)

  proc dfs(u:int, prev:int, eid: int):int {.discardable.}=
    var dsum = 1
    for e in G[u]:
      if e.dst == prev: continue
      dsum += dfs(e.dst,u,e.id)
    var dsum2 = N - dsum
    if eid != -1:
      if dsum != dsum2:
        assert((s[u] - s[prev]) mod (dsum - dsum2) == 0)
        ans[eid] = abs(s[u] - s[prev]) div abs(dsum2 - dsum)
      else:
        assert(pending == -1)
        pending = eid
    return dsum
  dfs(0,-1,-1)
  if pending != -1:
    proc dfs2(u:int,prev:int = -1):int =
      var s = 0
      for e in G[u]:
        if e.dst == prev: continue
        assert ans[e.id] != -1
        s += ans[e.id]
        s += dfs2(e.dst,u)
      return s
    let
      u = a[pending]
      v = b[pending]
      p = dfs2(u,v)
      q = dfs2(v,u)
    ans[pending] = (s[u] - (p + q)) div (N div 2)

  for a in ans: echo a
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt(1)
    b[i] = nextInt(1)
  var s = newSeqWith(N, 0)
  for i in 0..<N:
    s[i] = nextInt()
  solve(N, a, b, s);
  return

main()
#}}}
