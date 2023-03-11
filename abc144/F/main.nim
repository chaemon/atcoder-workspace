#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

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

#{{{ Graph[T]
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

#proc newGraph[T](n:int):Graph[T]=
#  var g:Graph[T]
#  g = newSeqWith(n,newSeq[Edge[T]]())
#  return g
proc newGraph(n:int):Graph[int]=
  var g:Graph[int]
  g = newSeqWith(n,newSeq[Edge[int]]())
  return g

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

template `:=`(a, b: untyped): untyped =
  when declaredInScope a:
    a = b
  else:
    var a = b
  when not declared seiuchi:
    proc seiuchi(x: auto): auto {.discardable.} = x
  seiuchi(x = b)


proc solve(N:int, M:int, s:seq[int], t:seq[int]) =
  G := newGraph(N)
  for i in 0..<M: G.addEdge(s[i], t[i])
  dp := newSeq[float](N)
  dp[N-1] = 0.0
  for u in countdown(N-2,0):
    s := 0.0
    for e in G[u]: s += dp[e.dst]
    dp[u] = s / float(G[u].len) + 1.0
  ans := dp[0]
  for u in 0..<N-1:
    # stop from u
    if G[u].len == 1: continue
    dp := dp
    for v in countdown(N-2,0):
      if v > u: continue
      elif v == u:
        s := 0.0
        dp_max := -Inf
        for e in G[u]: s += dp[e.dst]; dp_max.max= dp[e.dst]
        dp[u] = (s - dp_max) / float(G[u].len - 1) + 1.0
      else:
        s := 0.0
        for e in G[v]: s += dp[e.dst]
        dp[v] = s / float(G[v].len) + 1.0
    ans.min=dp[0]
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var s = newSeqWith(M, 0)
  var t = newSeqWith(M, 0)
  for i in 0..<M:
    s[i] = nextInt(1)
    t[i] = nextInt(1)
  solve(N, M, s, t);
  return

main()
#}}}
