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

#{{{ diameter
proc visit[T](p,v:int, g:Graph[T]): (T,int) =
  result = (0,v)
  for e in g[v]:
    if e.dst != p:
      var t = visit(v, e.dst, g)
      t[0] += e.weight
      if result[0] < t[0]: result = t

proc diameter[T](g:Graph[T], r:int = 0):int =
  let r = visit(-1, 0, g);
  let t = visit(-1, r[1], g);
  return t[0]
#}}}

#{{{ heapqueue
#
#
#            Nim's Runtime Library
#        (c) Copyright 2016 Yuriy Glukhov
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.

type HeapQueue*[T] = object
  ## A heap queue, commonly known as a priority queue.
  data: seq[T]

proc initHeapQueue*[T](): HeapQueue[T] =
  result = HeapQueue[T](data:newSeq[T]())

proc len*[T](heap: HeapQueue[T]): int {.inline.} =
  ## Return the number of elements of `heap`.
  heap.data.len

proc `[]`*[T](heap: HeapQueue[T], i: Natural): T {.inline.} =
  ## Access the i-th element of `heap`.
  heap.data[i]

proc heapCmp[T](x, y: T): bool {.inline.} =
  return (x < y)

proc siftdown[T](heap: var HeapQueue[T], startpos, p: int) =
  ## 'heap' is a heap at all indices >= startpos, except possibly for pos.  pos
  ## is the index of a leaf with a possibly out-of-order value.  Restore the
  ## heap invariant.
  var pos = p
  var newitem = heap[pos]
  # Follow the path to the root, moving parents down until finding a place
  # newitem fits.
  while pos > startpos:
    let parentpos = (pos - 1) shr 1
    let parent = heap[parentpos]
    if heapCmp(newitem, parent):
      heap.data[pos] = parent
      pos = parentpos
    else:
      break
  heap.data[pos] = newitem

proc siftup[T](heap: var HeapQueue[T], p: int) =
  let endpos = len(heap)
  var pos = p
  let startpos = pos
  let newitem = heap[pos]
  # Bubble up the smaller child until hitting a leaf.
  var childpos = 2*pos + 1 # leftmost child position
  while childpos < endpos:
    # Set childpos to index of smaller child.
    let rightpos = childpos + 1
    if rightpos < endpos and not heapCmp(heap[childpos], heap[rightpos]):
      childpos = rightpos
    # Move the smaller child up.
    heap.data[pos] = heap[childpos]
    pos = childpos
    childpos = 2*pos + 1
  # The leaf at pos is empty now.  Put newitem there, and bubble it up
  # to its final resting place (by sifting its parents down).
  heap.data[pos] = newitem
  siftdown(heap, startpos, pos)

proc push*[T](heap: var HeapQueue[T], item: T) =
  ## Push `item` onto heap, maintaining the heap invariant.
  heap.data.add(item)
  siftdown(heap, 0, len(heap)-1)

proc pop*[T](heap: var HeapQueue[T]): T =
  ## Pop and return the smallest item from `heap`,
  ## maintaining the heap invariant.
  let lastelt = heap.data.pop()
  if heap.len > 0:
    result = heap[0]
    heap.data[0] = lastelt
    siftup(heap, 0)
  else:
    result = lastelt

proc del*[T](heap: var HeapQueue[T], index: Natural) =
  ## Removes the element at `index` from `heap`, maintaining the heap invariant.
  swap(heap.data[^1], heap.data[index])
  let newLen = heap.len - 1
  heap.data.setLen(newLen)
  if index < newLen:
    heap.siftup(index)

proc replace*[T](heap: var HeapQueue[T], item: T): T =
  ## Pop and return the current smallest value, and add the new item.
  ## This is more efficient than pop() followed by push(), and can be
  ## more appropriate when using a fixed-size heap. Note that the value
  ## returned may be larger than item! That constrains reasonable uses of
  ## this routine unless written as part of a conditional replacement:
  ##
  ## .. code-block:: nim
  ##    if item > heap[0]:
  ##        item = replace(heap, item)
  result = heap[0]
  heap.data[0] = item
  siftup(heap, 0)

proc pushpop*[T](heap: var HeapQueue[T], item: T): T =
  ## Fast version of a push followed by a pop.
  if heap.len > 0 and heapCmp(heap[0], item):
    swap(item, heap[0])
    siftup(heap, 0)
  return item

proc clear*[T](heap: var HeapQueue[T]) =
  heap.data.setLen(0)

proc `$`*[T](heap: HeapQueue[T]): string =
  ## Turn a heap into its string representation.
  result = "["
  for x in heap.data:
    if result.len > 1: result.add(", ")
    result.addQuoted(x)
  result.add("]")

#}}}

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight

proc shortestPath[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
  var
    n = g.len
    dist = newSeqWith(n,T.infty)
    prev = newSeqWith(n,-1)
    Q = initHeapQueue[Edge[T]]()
  dist[s] = 0
  Q.push(newEdge[int](-2,s,0))
  while Q.len > 0:
    var e = Q.pop()
    if prev[e.dst] != -1: continue
    prev[e.dst] = e.src;
    for f in g[e.dst]:
      let w = e.weight + f.weight;
      if dist[f.dst] > w:
        dist[f.dst] = w;
        Q.push(newEdge(f.src, f.dst, w))
  return (dist,prev)

proc path(t: int, prev: seq[int]): seq[int] = 
  var
    u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()


proc solve(N:int, S:seq[string]) =
  var G = newGraph[int](N)
  for u in 0..<N:
    for v in u+1..<N:
      if S[u][v] == '1': G.addBiEdge(u,v)
  var color = newSeqWith(N,-1)
  proc dfs(u:int,prev:int,col:int):bool =
    if color[u] >= 0:
      if color[u] != col: return false
      else: return true
    color[u] = col
    for e in G[u]:
      if e.dst == prev: continue
      if not dfs(e.dst,u, 1 - col): return false
    return true

  for u in 0..<N:
    if color[u] >= 0: continue
    if not dfs(u,-1,0):
      echo -1
      return
  
  var ans = 0
  for u in 0..<N:
    var
      (dist, prev) = shortestPath(G,u)
      max_dist = 0
    for v in 0..<N:
      if dist[v] != int.infty:
        max_dist.max=dist[v]
    ans.max= max_dist
  echo ans + 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = newSeqWith(N, "")
  for i in 0..<N:
    S[i] = nextString()
  solve(N, S);
  return

main()
#}}}
