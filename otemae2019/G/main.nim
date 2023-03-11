#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

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

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}

#{{{ Compress
import sequtils
import algorithm

type Compress[T] = object
  xs: seq[T]

proc newCompress[T](xs:seq[T]):Compress[T] =
  result = Compress[T](xs:xs)
  result.build()

proc add[T](self:var Compress[T];t:T) =
  self.xs.add(t)
proc add[T](self:var Compress[T];v:seq[T]) =
  for t in v: self.add(t)

proc build[T](self:var Compress[T]) =
  self.xs.sort(cmp[T])
  self.xs = self.xs.deduplicate()

proc get[T](self:Compress[T], t:T):int =
  return self.xs.lowerBound(t)
proc get[T](self:Compress[T], v:seq[T]):seq[int] =
  result = newSeq[int]()
  for t in v: result.add(self.get(t))
proc `[]`[T](self:Compress[T], k:int):T = self.xs[k]
proc len[T](self:Compress[T]):int = self.xs.len
iterator items[T](self:Compress[T]):T =
  for x in self.xs: yield x

#}}}

#{{{ Graph
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]

proc newEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

proc newGraph[T](n:int):Graph[T] = newSeqWith(n,newSeq[Edge[T]]())

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

#{{{ HeapQueue[T]
type HeapQueue*[T] = object
  ## A heap queue, commonly known as a priority queue.
  data: seq[T]

proc initHeapQueue*[T](): HeapQueue[T] =
  ## Create a new empty heap.
  return HeapQueue[T](data: newSeq[T]())

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
  ## Remove all elements from `heap`, making it empty.
  heap.data.setLen(0)

proc `$`*[T](heap: HeapQueue[T]): string =
  ## Turn a heap into its string representation.
  result = "["
  for x in heap.data:
    if result.len > 1: result.add(", ")
    result.addQuoted(x)
  result.add("]")

#}}}

proc dijkstra[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
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
      var w = e.weight + f.weight;
      if dist[f.dst] > w:
        dist[f.dst] = w;
        Q.push(newEdge[T](f.src, f.dst, w))
    discard
  return (dist,prev)

proc path(t: int, prev: seq[int]): seq[int] = 
  var u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()

let dir:seq[tuple[x:int, y:int]] = @[(1, 0), (0, 1)]

proc solve(N:int, M:int, P:int, Q:int, R:int, S:int, 
           T:seq[int], A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  xs := newSeq[int]()
  ys := newSeq[int]()
  xs.add(P);ys.add(Q)
  xs.add(R);ys.add(S)
  for k in 0..<M: xs.add(A[k]);ys.add(B[k]);xs.add(C[k]);ys.add(D[k])
  cx := newCompress(xs)
  cy := newCompress(ys)
  G := newGraph[int](cx.len * cy.len)
  let id = (i:int, j:int) => i * cy.len + j
  for i in 0..<cx.len:
    for j in 0..<cy.len:
      for d in dir:
        let
          i2 = i + d.x
          j2 = j + d.y
        if not (0 <= i2 and i2 < cx.len and 0 <= j2 and j2 < cy.len): continue
        let D = abs(cx[i2] - cx[i]) + abs(cy[j2] - cy[j])
        G.addBiEdge(id(i,j), id(i2,j2), D)
  v := newSeq[((int, int), (int,int))]()
  for k in 0..<M:
    if T[k] == 1: v.add(((A[k], 0), (C[k], D[k])));v.add(((B[k], 1), (C[k], D[k])))
  v.sort()
  var i = 0
  for x in xs:
    if v[i][0][0] = x
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var P = 0
  P = nextInt()
  var Q = 0
  Q = nextInt()
  var R = 0
  R = nextInt()
  var S = 0
  S = nextInt()
  var T = newSeqWith(M, 0)
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  var D = newSeqWith(M, 0)
  for i in 0..<M:
    T[i] = nextInt()
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, M, P, Q, R, S, T, A, B, C, D);
  return

main()
#}}}
