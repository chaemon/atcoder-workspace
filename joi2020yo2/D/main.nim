#{{{ header
{.hints:off warnings:off optimization:speed.}
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
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

var M:int
var R:int

#{{{ input part
proc main()
block:
  M = nextInt()
  R = nextInt()
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

proc initEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

proc initGraph[T](n:int):Graph[T] =
  return newSeqWith(n,newSeq[Edge[T]]())

proc addBiEdge[T](g:var Graph[T],e:Edge[T]):void =
  var e_rev = e
  swap(e_rev.src, e_rev.dst)
  let (r, s) = (g[e.src].len, g[e.dst].len)
  g[e.src].add(e)
  g[e.dst].add(e_rev)
  g[e.src][^1].rev = s
  g[e.dst][^1].rev = r
proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addBiEdge(initEdge(src, dst, weight))

proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

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

proc pos(d:int):(int,int) =
  if d == 0: return (0, 0)
  else: return ((d - 1) div 3 + 1, (d - 1) mod 3)

var jump = newSeqWith(10, newSeqWith(10, -1))

for d in 0..9:
  let (x, y) = pos(d)
  for d2 in 0..9:
    let (x2, y2) = pos(d2)
    jump[d][d2] = abs(x - x2) + abs(y - y2)

proc dijkstra[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
  var
    n = g.len
    dist = newSeqWith(n,T.inf)
    prev = newSeqWith(n,-1)
    Q = initHeapQueue[Edge[T]]()
  dist[s] = T(0)
  Q.push(initEdge[T](-2,s,T(0)))
  while Q.len > 0:
    var e = Q.pop()
    if prev[e.dst] != -1: continue
    prev[e.dst] = e.src;
    for f in g[e.dst]:
      var w = e.weight + f.weight;
      if dist[f.dst] > w:
        dist[f.dst] = w;
        Q.push(initEdge[T](f.src, f.dst, w))
    discard
  return (dist,prev)

proc path(t: int, prev: seq[int]): seq[int] = 
  var u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()

main()

type S = object
  dist: int
  r: int
  p: int

proc `<`(x, y:S):bool = x.dist < y.dist

proc main() =
  dist := newSeqWith(M, newSeqWith(10, int.inf))
  Q := initHeapQueue[S]() # dist, remainder, pos
  dist[0][0] = 0
  Q.push(S(dist:0, p:0, r: 0))
  while Q.len > 0:
    var e = Q.pop()
    let (d, r, p) = (e.dist, e.r, e.p)
    if r == R:
      echo d;return
    if dist[r][p] < d: continue
#    if prev[e.dst] != -1: continue
#    prev[e.dst] = e.src;
    for p2 in 0..<10:
      let
        d2 = d + jump[p][p2] + 1
        r2 = (r * 10 + p2) mod M
      if dist[r2][p2] > d2:
        dist[r2][p2] = d2
        Q.push(S(dist:d2, r:r2, p:p2))
    discard

  return
