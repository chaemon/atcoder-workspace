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

#{{{ gridBfs
type S = object
  cost: int
  x, y:int

proc `<`(s,t:S):bool = s.cost < t.cost

proc gridBfs(s:openarray[string], start:char, X:int):seq[seq[int]] =
  let (R, C) = (s.len, s[0].len)
  proc inner(x, y:int):bool = (0 <= x and x < R and 0 <= y and y < C)
  let
    vx = [0,1, 0,-1]
    vy = [1,0,-1, 0]
  var min_cost = newSeqWith(R, newSeqWith(C, -1))
  var que = initHeapQueue[S]()
  for i in 0..<R:
    for j in 0..<C:
      if s[i][j] == start:
        que.push(S(cost:0, x:i, y:j))
        min_cost[i][j] = 0
  while que.len > 0:
    let p = que.pop
    for i in 0..<vx.len:
      let
        nx = p.x + vx[i]
        ny = p.y + vy[i]
      if not inner(nx, ny): continue
      if min_cost[nx][ny] != -1: continue
      if s[nx][ny] == '#':
        min_cost[nx][ny] = min_cost[p.x][p.y] + X
        que.push(S(cost: min_cost[nx][ny], x:nx, y:ny))
      else:
        min_cost[nx][ny] = min_cost[p.x][p.y] + 1
        que.push(S(cost: min_cost[nx][ny], x:nx, y:ny))
  return min_cost
#}}}

import future

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}
#{{{ findFirst(f, l, r), findLast(f, l, r)
proc findFirst(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  if not f(l): return -float(Inf)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): l = m
    else: r = m
  return l
#}}}

var H, W, T:int

H = nextInt()
W = nextInt()
T = nextInt()

var s = newSeqWith(H, "")
for i in 0..<H: s[i] = nextString()

var gx, gy:int

proc calc(X:int):bool =
  let dist = s.gridBfs('S', X)
  if dist[gx][gy] <= T: return true
  else: return false

for i in 0..<H:
  for j in 0..<W:
    if s[i][j] == 'G':
      gx = i
      gy = j
      s[i][j] = '.'

echo findLast(calc, 0..10^10)


