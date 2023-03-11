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

#{{{ heapQueue

import future

type HeapQueue*[T] = ref object
  data:seq[T]
  cmp:(T,T)->int

proc newHeapQueue*[T](cmp:proc (x,y:T):int = system.cmp[T]): HeapQueue[T] {.inline.} = HeapQueue[T](data:newSeq[T](),cmp:cmp)
proc newHeapQueue*[T](h: var HeapQueue[T], cmp:(T,T)->int = cmp[T]) {.inline.} = h = HeapQueue[T](data:newSeq[T](),cmp:cmp)

proc len*[T](h: HeapQueue[T]): int {.inline.} = h.data.len
proc `[]`*[T](h: HeapQueue[T], i: int): T {.inline.} = h.data[i]
proc `[]=`[T](h: var HeapQueue[T], i: int, v: T) {.inline.} = h.data[i] = v
proc add[T](h: var HeapQueue[T], v: T) {.inline.} = h.data.add(v)

#proc heapCmp[T](x, y: T): bool {.inline.} =
#  return (x < y)

proc siftdown[T](heap: var HeapQueue[T], startpos, p: int) =
  var pos = p
  var newitem = heap[pos]
  # Follow the path to the root, moving parents down until finding a place
  # newitem fits.
  while pos > startpos:
    let parentpos = (pos - 1) shr 1
    let parent = heap[parentpos]
    if heap.cmp(newitem, parent) < 0:
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
    if rightpos < endpos and heap.cmp(heap[childpos], heap[rightpos])>=0:
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
  heap.data.add(item)
  siftdown(heap, 0, len(heap)-1)

proc pop*[T](heap: var HeapQueue[T]): T =
  ## Pop the smallest item off the heap, maintaining the heap invariant.
  let lastelt = heap.data.pop()
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
  if heap.len > 0 and heap.cmp(heap[0], item)<0:
    swap(item, heap[0])
    siftup(heap, 0)
  return item
#}}}

proc solve(N:int, M:int, A:seq[int]) =
  var q = newHeapQueue[int]((a:int,b:int) => -cmp[int](a,b))
#  var q = newHeapQueue[int]()
  for i in 0..<N:
    q.push(A[i])
  for i in 0..<M:
    var t = (q.pop()) div 2
    q.push(t)
  var ans = 0
  for i in 0..<N:
    ans += q.pop()
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  solve(N, M, A);
  return

main()
#}}}
