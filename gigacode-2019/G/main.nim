#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(initEdge(src,dst,weight,g[dst].len))
  g[dst].add(initEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(initEdge(src,dst,weight,-1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

#{{{ Deque[T]
import math, typetraits

type
  Deque*[T] = object
    ## A double-ended queue backed with a ringed seq buffer.
    ##
    ## To initialize an empty deque use `initDeque proc <#initDeque,int>`_.
    data: seq[T]
    head, tail, count, mask: int

proc initDeque*[T](initialSize: int = 4): Deque[T] =
  ## Create a new empty deque.
  ##
  ## Optionally, the initial capacity can be reserved via `initialSize`
  ## as a performance optimization.
  ## The length of a newly created deque will still be 0.
  ##
  ## ``initialSize`` must be a power of two (default: 4).
  ## If you need to accept runtime values for this you could use the
  ## `nextPowerOfTwo proc<math.html#nextPowerOfTwo,int>`_ from the
  ## `math module<math.html>`_.
  assert isPowerOfTwo(initialSize)
  result.mask = initialSize-1
  newSeq(result.data, initialSize)

proc len*[T](deq: Deque[T]): int {.inline.} =
  ## Return the number of elements of `deq`.
  result = deq.count

template emptyCheck(deq) =
  # Bounds check for the regular deque access.
  when compileOption("boundChecks"):
    if unlikely(deq.count < 1):
      raise newException(IndexError, "Empty deque.")

template xBoundsCheck(deq, i) =
  # Bounds check for the array like accesses.
  when compileOption("boundChecks"): # d:release should disable this.
    if unlikely(i >= deq.count): # x < deq.low is taken care by the Natural parameter
      raise newException(IndexError,
                         "Out of bounds: " & $i & " > " & $(deq.count - 1))
    if unlikely(i < 0): # when used with BackwardsIndex
      raise newException(IndexError,
                         "Out of bounds: " & $i & " < 0")

proc `[]`*[T](deq: Deque[T], i: Natural): T {.inline.} =
  ## Access the i-th element of `deq`.

  xBoundsCheck(deq, i)
  return deq.data[(deq.head + i) and deq.mask]

proc `[]`*[T](deq: var Deque[T], i: Natural): var T {.inline.} =
  ## Access the i-th element of `deq` and return a mutable
  ## reference to it.
  xBoundsCheck(deq, i)
  return deq.data[(deq.head + i) and deq.mask]

proc `[]=`*[T](deq: var Deque[T], i: Natural, val: T) {.inline.} =
  ## Change the i-th element of `deq`.

  xBoundsCheck(deq, i)
  deq.data[(deq.head + i) and deq.mask] = val

iterator items*[T](deq: Deque[T]): T =
  ## Yield every element of `deq`.
  ##
  ## **Examples:**
  ##
  ## .. code-block::
  ##   var a = initDeque[int]()
  ##   for i in 1 .. 3:
  ##     a.addLast(10*i)
  ##
  ##   for x in a:  # the same as: for x in items(a):
  ##     echo x
  ##
  ##   # 10
  ##   # 20
  ##   # 30
  ##
  var i = deq.head
  for c in 0 ..< deq.count:
    yield deq.data[i]
    i = (i + 1) and deq.mask

iterator mitems*[T](deq: var Deque[T]): var T =
  ## Yield every element of `deq`, which can be modified.

  var i = deq.head
  for c in 0 ..< deq.count:
    yield deq.data[i]
    i = (i + 1) and deq.mask

iterator pairs*[T](deq: Deque[T]): tuple[key: int, val: T] =
  ## Yield every (position, value) of `deq`.
  ##
  ## **Examples:**
  ##
  ## .. code-block::
  ##   var a = initDeque[int]()
  ##   for i in 1 .. 3:
  ##     a.addLast(10*i)
  ##
  ##   for k, v in pairs(a):
  ##     echo "key: ", k, ", value: ", v
  ##
  ##   # key: 0, value: 10
  ##   # key: 1, value: 20
  ##   # key: 2, value: 30
  ##
  var i = deq.head
  for c in 0 ..< deq.count:
    yield (c, deq.data[i])
    i = (i + 1) and deq.mask

proc contains*[T](deq: Deque[T], item: T): bool {.inline.} =
  ## Return true if `item` is in `deq` or false if not found.
  ##
  ## Usually used via the ``in`` operator.
  ## It is the equivalent of ``deq.find(item) >= 0``.
  ##
  ## .. code-block:: Nim
  ##   if x in q:
  ##     assert q.contains(x)
  for e in deq:
    if e == item: return true
  return false

proc expandIfNeeded[T](deq: var Deque[T]) =
  var cap = deq.mask + 1
  if unlikely(deq.count >= cap):
    var n = newSeq[T](cap * 2)
    for i, x in pairs(deq): # don't use copyMem because the GC and because it's slower.
      shallowCopy(n[i], x)
    shallowCopy(deq.data, n)
    deq.mask = cap * 2 - 1
    deq.tail = deq.count
    deq.head = 0

proc addFirst*[T](deq: var Deque[T], item: T) =
  ## Add an `item` to the beginning of the `deq`.
  ##
  ## See also:
  ## * `addLast proc <#addLast,Deque[T],T>`_
  ## * `peekFirst proc <#peekFirst,Deque[T]>`_
  ## * `peekLast proc <#peekLast,Deque[T]>`_
  ## * `popFirst proc <#popFirst,Deque[T]>`_
  ## * `popLast proc <#popLast,Deque[T]>`_

  expandIfNeeded(deq)
  inc deq.count
  deq.head = (deq.head - 1) and deq.mask
  deq.data[deq.head] = item

proc addLast*[T](deq: var Deque[T], item: T) =
  ## Add an `item` to the end of the `deq`.
  ##
  ## See also:
  ## * `addFirst proc <#addFirst,Deque[T],T>`_
  ## * `peekFirst proc <#peekFirst,Deque[T]>`_
  ## * `peekLast proc <#peekLast,Deque[T]>`_
  ## * `popFirst proc <#popFirst,Deque[T]>`_
  ## * `popLast proc <#popLast,Deque[T]>`_

  expandIfNeeded(deq)
  inc deq.count
  deq.data[deq.tail] = item
  deq.tail = (deq.tail + 1) and deq.mask

proc peekFirst*[T](deq: Deque[T]): T {.inline.} =
  ## Returns the first element of `deq`, but does not remove it from the deque.
  ##
  ## See also:
  ## * `addFirst proc <#addFirst,Deque[T],T>`_
  ## * `addLast proc <#addLast,Deque[T],T>`_
  ## * `peekLast proc <#peekLast,Deque[T]>`_
  ## * `popFirst proc <#popFirst,Deque[T]>`_
  ## * `popLast proc <#popLast,Deque[T]>`_

  emptyCheck(deq)
  result = deq.data[deq.head]

proc peekLast*[T](deq: Deque[T]): T {.inline.} =
  ## Returns the last element of `deq`, but does not remove it from the deque.
  ##
  ## See also:
  ## * `addFirst proc <#addFirst,Deque[T],T>`_
  ## * `addLast proc <#addLast,Deque[T],T>`_
  ## * `peekFirst proc <#peekFirst,Deque[T]>`_
  ## * `popFirst proc <#popFirst,Deque[T]>`_
  ## * `popLast proc <#popLast,Deque[T]>`_

  emptyCheck(deq)
  result = deq.data[(deq.tail - 1) and deq.mask]

template destroy(x: untyped) =
  reset(x)

proc popFirst*[T](deq: var Deque[T]): T {.inline, discardable.} =
  ## Remove and returns the first element of the `deq`.
  ##
  ## See also:
  ## * `addFirst proc <#addFirst,Deque[T],T>`_
  ## * `addLast proc <#addLast,Deque[T],T>`_
  ## * `peekFirst proc <#peekFirst,Deque[T]>`_
  ## * `peekLast proc <#peekLast,Deque[T]>`_
  ## * `popLast proc <#popLast,Deque[T]>`_
  ## * `clear proc <#clear,Deque[T]>`_
  ## * `shrink proc <#shrink,Deque[T],int,int>`_

  emptyCheck(deq)
  dec deq.count
  result = deq.data[deq.head]
  destroy(deq.data[deq.head])
  deq.head = (deq.head + 1) and deq.mask

proc popLast*[T](deq: var Deque[T]): T {.inline, discardable.} =
  ## Remove and returns the last element of the `deq`.
  ##
  ## See also:
  ## * `addFirst proc <#addFirst,Deque[T],T>`_
  ## * `addLast proc <#addLast,Deque[T],T>`_
  ## * `peekFirst proc <#peekFirst,Deque[T]>`_
  ## * `peekLast proc <#peekLast,Deque[T]>`_
  ## * `popFirst proc <#popFirst,Deque[T]>`_
  ## * `clear proc <#clear,Deque[T]>`_
  ## * `shrink proc <#shrink,Deque[T],int,int>`_

  emptyCheck(deq)
  dec deq.count
  deq.tail = (deq.tail - 1) and deq.mask
  result = deq.data[deq.tail]
  destroy(deq.data[deq.tail])

proc clear*[T](deq: var Deque[T]) {.inline.} =
  ## Resets the deque so that it is empty.
  ##
  ## See also:
  ## * `clear proc <#clear,Deque[T]>`_
  ## * `shrink proc <#shrink,Deque[T],int,int>`_

  for el in mitems(deq): destroy(el)
  deq.count = 0
  deq.tail = deq.head

proc shrink*[T](deq: var Deque[T], fromFirst = 0, fromLast = 0) =
  ## Remove `fromFirst` elements from the front of the deque and
  ## `fromLast` elements from the back.
  ##
  ## If the supplied number of elements exceeds the total number of elements
  ## in the deque, the deque will remain empty.
  ##
  ## See also:
  ## * `clear proc <#clear,Deque[T]>`_

  if fromFirst + fromLast > deq.count:
    clear(deq)
    return

  for i in 0 ..< fromFirst:
    destroy(deq.data[deq.head])
    deq.head = (deq.head + 1) and deq.mask

  for i in 0 ..< fromLast:
    destroy(deq.data[deq.tail])
    deq.tail = (deq.tail - 1) and deq.mask

  dec deq.count, fromFirst + fromLast

proc `$`*[T](deq: Deque[T]): string =
  ## Turn a deque into its string representation.
  result = "["
  for x in deq:
    if result.len > 1: result.add(", ")
    result.addQuoted(x)
  result.add("]")
#}}}

#import heapqueue

proc dijkstra[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
  var
    n = g.len
    dist = newSeqWith(n,T.infty)
    prev = newSeqWith(n,-1)
    Q = initDeque[Edge[T]]()
  dist[s] = 0
  Q.addLast(initEdge[int](-2,s,0))
  while Q.len > 0:
    var e = Q.popFirst()
    if prev[e.dst] != -1: continue
    prev[e.dst] = e.src;
    for f in g[e.dst]:
      var w = e.weight + f.weight;
      if dist[f.dst] > w:
        dist[f.dst] = w;
        Q.addLast(initEdge[T](f.src, f.dst, w))
    discard
  return (dist,prev)

proc path(t: int, prev: seq[int]): seq[int] = 
  var u = t
  while u >= 0:
    result.add(u)
    u = prev[u]
  result.reverse()


#{{{ ReRooting: initReRooting[Weight, Data](n:int, f_up(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data)
import sequtils, future
type
  Node[Weight] = object
    to, rev: int
    data: Weight
  ReRooting[Weight, Data] = object
    g:seq[seq[Node[Weight]]]
    ldp, rdp: seq[seq[Data]]
    lptr, rptr: seq[int]
    ident: Data
    f_up: (Data,Weight)->Data
    f_merge: (Data,Data)->Data

proc initNode[Weight](to, rev:int, d: Weight):Node[Weight] = Node[Weight](to: to, rev: rev, data: d)
proc initReRooting[Weight, Data](n:int, f_up:(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data):ReRooting[Weight,Data] =
  return ReRooting[Weight,Data](
    g:newSeqWith(n, newSeq[Node[Weight]]()),
    ldp:newSeqWith(n, newSeq[Data]()),
    rdp:newSeqWith(n, newSeq[Data]()),
    lptr:newSeq[int](n), rptr:newSeq[int](n),
    f_up:f_up, f_merge:f_merge, ident:ident)

proc addEdge[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, d))
proc addEdgeBi[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d,e:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, e))
proc dfs[Weight, Data](self: var ReRooting[Weight, Data], idx, par:int):Data =
  while self.lptr[idx] != par and self.lptr[idx] < self.g[idx].len:
    var e = self.g[idx][self.lptr[idx]].addr
    self.ldp[idx][self.lptr[idx] + 1] = self.f_merge(self.ldp[idx][self.lptr[idx]], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.lptr[idx] += 1
  while self.rptr[idx] != par and self.rptr[idx] >= 0:
    var e = self.g[idx][self.rptr[idx]].addr
    self.rdp[idx][self.rptr[idx]] = self.f_merge(self.rdp[idx][self.rptr[idx] + 1], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.rptr[idx] -= 1
  if par < 0: return self.rdp[idx][0]
  return self.f_merge(self.ldp[idx][par], self.rdp[idx][par + 1])

proc solve[Weight, Data](self: var ReRooting[Weight, Data]):seq[Data] =
  for i in 0..<self.g.len:
    self.ldp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.rdp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.lptr[i] = 0
    self.rptr[i] = self.g[i].len - 1
  result = newSeq[Data]()
  for i in 0..<self.g.len: result.add(self.dfs(i, -1))
#}}}

proc solve(N:int, M:int, a:seq[int], b:seq[int]) =
  if (N <= 3000 and M <= 3000):
    var g = initGraph[int](N)
    for i in 0..<M:g.addBiEdge(a[i], b[i])
    var ans = 0
    for r in 0..<N:
      let (dist, _) = dijkstra(g, r)
      ans += sum(dist)
    echo ans div 2
  elif M - N == -1:
    # (sum, num)
    proc f_up(a:(int,int), data: int):(int,int) = (a[0] + a[1] + 1, a[1] + 1)
    proc f_merge(a, b:(int,int)):(int,int) = (a[0] + b[0], a[1] + b[1])
    var g = initReRooting[int, (int,int)](N, f_up, f_merge, (0,0))
    var s = 0
    for i in 0..<M:
      g.addEdge(a[i], b[i], 0)
    for p in g.solve:
      s += p[0]
    echo s div 2
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt(1)
    b[i] = nextInt(1)
  solve(N, M, a, b)
  return

main()
#}}}


