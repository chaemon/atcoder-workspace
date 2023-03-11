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

var N:int
var C:int
var h:seq[int]

#{{{ input part
block:
  N = nextInt()
  C = nextInt()
  h = newSeqWith(N, nextInt())
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

# ConvexHullTrickAddMonotone {{{
type ConvexHullTrickAddMonotone[T] = object
  isMin:bool
  H:Deque[(T,T)]

proc initConvexHullTrickAddMonotone[T](isMin:bool):ConvexHullTrickAddMonotone[T] =
  return ConvexHullTrickAddMonotone[T](H:initDeque[(T, T)](), isMin:isMin)

proc empty[T](self: ConvexHullTrickAddMonotone[T]):bool = self.H.len == 0

#  void clear() { H.clear(); }

proc sgn[T](self: ConvexHullTrickAddMonotone[T], x:T):int =
  return if x == T(0): 0 else: if x < T(0):  -1 else: 1

proc check[T](self: ConvexHullTrickAddMonotone[T], a,b,c:(T,T)):bool =
  if b[1] == a[1] or c[1] == b[1]:
    return self.sgn(b[0] - a[0]) * self.sgn(c[1] - b[1]) >= self.sgn(c[0] - b[0]) * self.sgn(b[1] - a[1])

  #return (b[0]-a[0])*(c[1]-b[1]) >= (b[1]-a[1])*(c[0]-b[0]);
  return
      (b[0] - a[0]).float * self.sgn(c[1] - b[1]).float / abs(b[1] - a[1]).float >= (c[0] - b[0]).float * self.sgn(b[1] - a[1]).float / abs(c[1] - b[1]).float

proc add[T](self: var ConvexHullTrickAddMonotone[T], a, b:T) =
  var (a, b) = (a, b)
  if not self.isMin:
    a *= -1;b *= -1
  let line = (a, b)
  if self.empty():
    self.H.addFirst(line)
    return;
  if self.H[0][0] <= a:
    if self.H[0][0] == a:
      if self.H[0][1] <= b: return
      self.H.popFirst
    while self.H.len >= 2 and self.check(line, self.H[0], self.H[1]): self.H.popFirst
    self.H.addFirst(line)
  else:
    assert(a <= self.H[self.H.len-1][0])
    if self.H[self.H.len-1][0] == a:
      if self.H[self.H.len-1][1] <= b: return
      self.H.popLast()
    while self.H.len >= 2 and self.check(self.H[self.H.len-2], self.H[self.H.len-1], line): self.H.popLast
    self.H.addLast(line)

proc get_y[T](self: ConvexHullTrickAddMonotone[T], a:(T, T), x:T):T =
  return a[0] * x + a[1];

proc query[T](self: ConvexHullTrickAddMonotone[T], x:T):T =
  assert(not self.empty())
  var (l, r) = (-1, self.H.len - 1)
  while l + 1 < r:
    let m = (l + r) shr 1
    if self.get_y(self.H[m], x) >= self.get_y(self.H[m + 1], x): l = m
    else: r = m
  if self.isMin: return self.get_y(self.H[r], x)
  return -self.get_y(self.H[r], x)

proc query_monotone_inc[T](self: var ConvexHullTrickAddMonotone[T], x:T):T =
  assert(not self.empty())
  while self.H.len >= 2 and self.get_y(self.H[0], x) >= self.get_y(self.H[1], x): self.H.popFirst
  if self.isMin: return self.get_y(self.H[0], x)
  return -self.get_y(self.H[0], x)

proc query_monotone_dec[T](self: var ConvexHullTrickAddMonotone[T], x:T):T =
  assert(not self.empty())
  while self.H.size() >= 2 and get_y(self.H[self.H.len - 1], x) >= self.get_y(self.H[self.H.len - 2], x): self.H.popLast
  if self.isMin: return self.get_y(self.H[self.H.len - 1], x)
  return -self.get_y(self.H[self.H.len - 1], x)
#}}}

block main:
  var cht = initConvexHullTrickAddMonotone[int](isMin = true)
  cht.add(-2*h[0], h[0]^2 + C)
  for x in 1..<N:
#    let d = cht.query_monotone_inc(h[x]) + h[x] ^ 2
    let d = cht.query(h[x]) + h[x] ^ 2
    cht.add(-2*h[x],  d + h[x] ^ 2 + C)
    if x == N - 1: echo d


