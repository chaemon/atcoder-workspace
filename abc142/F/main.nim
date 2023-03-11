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

proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  var G = newGraph[int](N)
  var a = newSeqWith(N,newSeqWith(N,false))
  for i in 0..<M:
    G.addEdge(A[i],B[i])
    a[A[i]][B[i]] = true
  var prev = newSeq[int](N)
  var s = initSet[int]()
  var vis = newSeq[bool](N)
  var ans = newSeq[int]()
  proc dfs(u:int):void =
    if ans.len > 0: return
    vis[u] = true
    for e in G[u]:
      if e.dst in s:# found
        var t = u
        while true:
          ans.add(t)
          if t == e.dst:
            break
          t = prev[t]
        return
      prev[e.dst] = u
      s.incl(e.dst)
      dfs(e.dst)
      if ans.len > 0:return
      s.excl(e.dst)
      prev[e.dst] = -1
  for u in 0..<N:
    s = initSet[int]()
    if not vis[u]: dfs(u)
    if ans.len>0:
      ans.reverse
      break
  if ans.len == 0:
    echo -1
    return
  while true:
    var found = false
    var
      i0 = -1
      j0 = -1
    for i in 0..<ans.len:
      for j in 0..<ans.len:
        if (i + 1) mod ans.len == j: continue
        if a[ans[i]][ans[j]]:
          i0 = i
          j0 = j
          found = true
          break
      if found: break
    if found:
      var ans_ji = newSeq[int]()
      var p = j0
      while true:
        ans_ji.add(ans[p])
        if p == i0: break
        p = (p + 1) mod ans.len
      ans = ans_ji
    else:
      break
  echo ans.len
  for u in ans:
    echo u + 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt(1)
    B[i] = nextInt(1)
  solve(N, M, A, B);
  return

main()
#}}}
