#{{{ header
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

proc sort[T](a:var seq[T]) = a.sort(cmp[T])

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

#{{{ topological sort
import options

proc topologicalSort[T](g:Graph[T]):Option[seq[int]] =
  let n = g.len
  var
    color = newSeq[int](n)
    order = newSeq[int]()

  proc visit(v:int): bool =
    color[v] = 1
    var next = newSeq[int]()
    for e in g[v]: next.add(e.dst)
    next.sort()
#    order.add(v)
    for u in next:
      if color[u] == 2: continue
      if color[u] == 1: return false
      if not visit(u): return false
    order.add(v)
    color[v] = 2
    return true

  for u in 0..<n:
    if color[u] == 0 and not visit(u): return none(seq[int])
  order.reverse
  return some(order)
#}}}

proc solve(N:int, A:seq[string], B:seq[string]) =
  var
    G = newGraph[int](26)
    e = newSeq[(int,int)]()
  for i in 0..<N:
    var j = 0
    while true:
      if j == B[i].len: echo -1;return
      elif j == A[i].len: break
      elif A[i][j] != B[i][j]:
        let 
          a = ord(A[i][j]) - ord('a')
          b = ord(B[i][j]) - ord('a')
        G.addEdge(a,b)
        e.add((a,b))
#        D[a][b] = 1
        break
      j += 1
  let r = topologicalSort(G)
  if r.isNone: echo -1;return
  var ans = newSeq[int]()
  proc test(v:seq[int]):bool =
    var rank = newSeqWith(26, -1)
    for i in 0..<v.len:
      rank[v[i]] = i
    for ei in e:
      let
        p = ei[0]
        q = ei[1]
      if rank[p] == -1:
        if rank[q] != -1: return false
      else:
        if rank[q] != -1:
          if rank[p] > rank[q]: return false
    return true
  for i in 0..<26:
    var unlisted = newSeq[int]()
    for j in 0..<26:
      if j notin ans: unlisted.add(j)
    var found = false
    for l in unlisted:
      ans.add(l)
      if test(ans):
        found = true
        break
      discard ans.pop()
    assert(found)
  for i in 0..<ans.len:
    stdout.write chr(ans[i] + ord('a'))
  echo ""
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, "")
  var B = newSeqWith(N, "")
  for i in 0..<N:
    A[i] = nextString()
    B[i] = nextString()
  solve(N, A, B);
  return

main()
#}}}


