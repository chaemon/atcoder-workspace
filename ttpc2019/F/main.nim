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

type HeapQueue*[T] = distinct seq[T]

proc newHeapQueue*[T](): HeapQueue[T] {.inline.} = HeapQueue[T](newSeq[T]())
proc newHeapQueue*[T](h: var HeapQueue[T]) {.inline.} = h = HeapQueue[T](newSeq[T]())

proc len*[T](h: HeapQueue[T]): int {.inline.} = seq[T](h).len
proc `[]`*[T](h: HeapQueue[T], i: int): T {.inline.} = seq[T](h)[i]
proc `[]=`[T](h: var HeapQueue[T], i: int, v: T) {.inline.} = seq[T](h)[i] = v
proc add[T](h: var HeapQueue[T], v: T) {.inline.} = seq[T](h).add(v)

proc heapCmp[T](x, y: T): bool {.inline.} =
  return (x < y)

# 'heap' is a heap at all indices >= startpos, except possibly for pos.  pos
# is the index of a leaf with a possibly out-of-order value.  Restore the
# heap invariant.
proc siftdown[T](heap: var HeapQueue[T], startpos, p: int) =
  var pos = p
  var newitem = heap[pos]
  # Follow the path to the root, moving parents down until finding a place
  # newitem fits.
  while pos > startpos:
    let parentpos = (pos - 1) shr 1
    let parent = heap[parentpos]
    if heapCmp(newitem, parent):
      heap[pos] = parent
      pos = parentpos
    else:
      break
  heap[pos] = newitem

proc siftup[T](heap: var HeapQueue[T], p: int) =
  let endpos = len(heap)
  var pos = p
  let startpos = pos
  let newitem = heap[pos]
  # Bubble up the smaller child until hitting a leaf.
  var childpos = 2*pos + 1    # leftmost child position
  while childpos < endpos:
    # Set childpos to index of smaller child.
    let rightpos = childpos + 1
    if rightpos < endpos and not heapCmp(heap[childpos], heap[rightpos]):
      childpos = rightpos
    # Move the smaller child up.
    heap[pos] = heap[childpos]
    pos = childpos
    childpos = 2*pos + 1
  # The leaf at pos is empty now.  Put newitem there, and bubble it up
  # to its final resting place (by sifting its parents down).
  heap[pos] = newitem
  siftdown(heap, startpos, pos)

proc push*[T](heap: var HeapQueue[T], item: T) =
  ## Push item onto heap, maintaining the heap invariant.
  (seq[T](heap)).add(item)
  siftdown(heap, 0, len(heap)-1)

proc pop*[T](heap: var HeapQueue[T]): T =
  ## Pop the smallest item off the heap, maintaining the heap invariant.
  let lastelt = seq[T](heap).pop()
  if heap.len > 0:
    result = heap[0]
    heap[0] = lastelt
    siftup(heap, 0)
  else:
    result = lastelt

proc del*[T](heap: var HeapQueue[T], index: int) =
  ## Removes element at `index`, maintaining the heap invariant.
  swap(seq[T](heap)[^1], seq[T](heap)[index])
  let newLen = heap.len - 1
  seq[T](heap).setLen(newLen)
  if index < newLen:
    heap.siftup(index)

proc replace*[T](heap: var HeapQueue[T], item: T): T =
  ## Pop and return the current smallest value, and add the new item.
  ## This is more efficient than pop() followed by push(), and can be
  ## more appropriate when using a fixed-size heap.  Note that the value
  ## returned may be larger than item!  That constrains reasonable uses of
  ## this routine unless written as part of a conditional replacement:

  ##    if item > heap[0]:
  ##        item = replace(heap, item)
  result = heap[0]
  heap[0] = item
  siftup(heap, 0)

proc pushpop*[T](heap: var HeapQueue[T], item: T): T =
  ## Fast version of a push followed by a pop.
  if heap.len > 0 and heapCmp(heap[0], item):
    swap(item, heap[0])
    siftup(heap, 0)
  return item

let NO = "Impossible"

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



proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight

proc shortestPath[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
  var
    n = g.len
    dist = newSeqWith(n,int.infty)
    prev = newSeqWith(n,-1)
    Q = newHeapQueue[Edge[T]]()
  dist[s] = 0
  Q.push(newEdge[int](-2,s,0))
  while Q.len > 0:
    var e = Q.pop()
    if prev[e.dst] != -1: continue
    prev[e.dst] = e.src;
    for f in g[e.dst]:
      var w = e.weight + f.weight;
      if dist[f.dst] > w:
        dist[f.dst] = w;
        Q.push(newEdge(f.src, f.dst, w))
    discard
  return (dist,prev)
proc path(t: int, prev: seq[int]): seq[int] = 
  var
    u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()

proc solve(N:int, M:int, w:int, x:int, y:int, z:int, c:seq[int], s:seq[int], t:seq[int]) =
  var
    G,H = newGraph[int](N)
  for i in 0..<M:
    G.addEdge(s[i],t[i],c[i])
    H.addEdge(t[i],s[i],c[i])
  let
    (distw,_) = shortestPath(G,w)
    (disty,_) = shortestPath(G,y)
    (distx,_) = shortestPath(H,x)
    (distz,_) = shortestPath(H,z)
  if distw[x] == int.infty or disty[z] == int.infty:
    echo NO;return
  var dp = newSeqWith(N,int.infty)
  var ans = distw[x] + disty[z]
  for u in 0..<N:
    if distw[u] != int.infty and disty[u] != int.infty:
      dp[u].min=(distw[u] + disty[u])
    for e in G[u]:
      dp[e.dst].min=(dp[u] + e.weight)
    ans.min=(dp[u] + distx[u] + distz[u])
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var w = 0
  w = nextInt().pred
  var x = 0
  x = nextInt().pred
  var y = 0
  y = nextInt().pred
  var z = 0
  z = nextInt().pred
  var c = newSeqWith(M, 0)
  var s = newSeqWith(M, 0)
  var t = newSeqWith(M, 0)
  for i in 0..<M:
    c[i] = nextInt()
    s[i] = nextInt().pred
    t[i] = nextInt().pred
  solve(N, M, w, x, y, z, c, s, t);
  return

main()
#}}}
