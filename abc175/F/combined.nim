# header {{{
{.hints:off warnings:off optimization:speed.}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
import strformat
import sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc discardableId[T](x: T): T {.discardable.} =
  return x

macro `:=`(x, y: untyped): untyped =
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

var N:int
var S:seq[string]
var C:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  S = newSeqWith(N, "")
  C = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextString()
    C[i] = nextInt()
#}}}

var forward_t = Array(50, 22, 50, -1)

proc forward(i,j,p:int):bool =
  let r = forward_t[i][j][p]
  if r >= 0: return r.bool
  let m = min(S[i].len - j, S[p].len)
  result = true
  for k in 0..<m:
    if S[i][j + k] != S[p][^(k + 1)]:
      result = false;break
  forward_t[i][j][p] = result.int

var backward_t = Array(50, 22, 50, -1)

proc backward(i, j, p:int):bool =
  let r = backward_t[i][j][p]
  if r >= 0: return r.bool
  let m = min(j + 1, S[p].len)
  result = true
  for k in 0..<m:
    if S[i][j - k] != S[p][k]:
      result = false;break
  backward_t[i][j][p] = result.int

proc palindrome(i, j:int):bool = forward(i, j, i)
proc rpalindrome(i, j:int):bool = backward(i, j, i)

# {{{ heapqueue

type HeapQueue*[T; heapCmp:static[auto]] = object
  ## A heap queue, commonly known as a priority queue.
  data: seq[T]

proc initHeapQueue*[T](heapCmp:static[proc(a, b:T):bool]): auto =
  ## Create a new empty heap.
  HeapQueue[T, heapCmp]()
proc initHeapQueue*[T](): auto =
  ## Create a new empty heap.
  HeapQueue[T, proc(a, b:T):bool = a < b]()

proc len*[H:HeapQueue](heap: H): int {.inline.} =
  ## Return the number of elements of `heap`.
  heap.data.len

proc `[]`*[H:HeapQueue](heap: H, i: Natural): H.T {.inline.} =
  ## Access the i-th element of `heap`.
  heap.data[i]

#proc heapCmp[T](x, y: T): bool {.inline.} =
#  return (x < y)

proc siftdown[H:HeapQueue](heap: var H, startpos, p: int) =
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
    let heapCmp = H.heapCmp
    if heapCmp(newitem, parent):
      heap.data[pos] = parent
      pos = parentpos
    else:
      break
  heap.data[pos] = newitem

proc siftup[H:HeapQueue](heap: var H, p: int) =
  let endpos = len(heap)
  var pos = p
  let startpos = pos
  let newitem = heap[pos]
  # Bubble up the smaller child until hitting a leaf.
  var childpos = 2*pos + 1 # leftmost child position
  while childpos < endpos:
    # Set childpos to index of smaller child.
    let rightpos = childpos + 1
    let heapCmp = H.heapCmp
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

proc push*[H:HeapQueue](heap: var H, item: H.T) =
  ## Push `item` onto heap, maintaining the heap invariant.
  heap.data.add(item)
  siftdown(heap, 0, len(heap)-1)

proc pop*[H:HeapQueue](heap: var H): H.T =
  ## Pop and return the smallest item from `heap`,
  ## maintaining the heap invariant.
  let lastelt = heap.data.pop()
  if heap.len > 0:
    result = heap[0]
    heap.data[0] = lastelt
    siftup(heap, 0)
  else:
    result = lastelt

proc del*[H:HeapQueue](heap: var H, index: Natural) =
  ## Removes the element at `index` from `heap`, maintaining the heap invariant.
  swap(heap.data[^1], heap.data[index])
  let newLen = heap.len - 1
  heap.data.setLen(newLen)
  if index < newLen:
    heap.siftup(index)

proc replace*[H:HeapQueue](heap: var H, item: H.T): H.T =
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

proc pushpop*[H:HeapQueue](heap: var H, item: H.T): H.T =
  ## Fast version of a push followed by a pop.
  let heapCmp = H.heapCmp
  if heap.len > 0 and heapCmp(heap[0], item):
    swap(item, heap[0])
    siftup(heap, 0)
  return item

proc clear*[H:HeapQueue](heap: var H) =
  ## Remove all elements from `heap`, making it empty.
  runnableExamples:
    var heap = initHeapQueue[int]()
    heap.push(1)
    heap.clear()
    assert heap.len == 0
  heap.data.setLen(0)

proc `$`*[H:HeapQueue](heap: H): string =
  ## Turn a heap into its string representation.
  runnableExamples:
    var heap = initHeapQueue[int]()
    heap.push(1)
    heap.push(2)
    assert $heap == "[1, 2]"
  result = "["
  for x in heap.data:
    if result.len > 1: result.add(", ")
    result.addQuoted(x)
  result.add("]")

# }}}

# custom dijkustra template {{{

import strformat
#import deques
#import heapqueue

macro `[]`(a: untyped, p: tuple): untyped =
  var strBody = fmt"{a.repr}"
  for i, _ in p.getTypeImpl: strBody &= fmt"[{p.repr}[{i}]]"
  parseStmt(strBody)
macro `[]=`(a: untyped, p: tuple, x: untyped): untyped =
  var strBody = fmt"{a.repr}"
  for i, _ in p.getTypeImpl: strBody &= fmt"[{p.repr}[{i}]]"
  strBody &= fmt" = {x.repr}"
  parseStmt(strBody)

#proc `<`(l,r:DP):bool = l.d < r.d


#type AT = adj.type

type GraphIterativeC = concept g, type G
  type W = G.Weight
  type P = G.P
  var x:P
  for p in adj(g, 1, x):
    discard

type HasDim = concept g
  g.dim


proc dijkstra[G:GraphIterativeC](g:G, s:g.P or openArray[g.P], limit = G.Weight.inf):auto =
  when g is HasDim:
    const UseTable = false
  else:
    const UseTable = true
  type P = g.P
  type Weight = g.Weight
  type DP = object
    d:int
    p:P

#  type PD = tuple[p:P, d:int]
  proc heapCmp(a, b:DP):bool =
    a.d < b.d

  when UseTable:
    var
      vis = initSet[P]()
      dist = initTable[P, Weight]()
  else:
    var
      dist = Seq(g.dim, limit)
      vis = Seq(g.dim, false)


  var Q = initHeapQueue(heapCmp)

  proc set_push(d:int, p:P) =
    when UseTable:
      if p in vis: return
      if p notin dist: dist[p] = limit
    else:
      if vis[p]: return
    if dist[p] <= d: return
    dist[p] = d
    Q.push(DP(d:d, p:p))

  when s isnot openArray:
    let s = [s]

  # initial
  for p in s:
    set_push(0, p)

  # iteration
  while Q.len > 0:
    let dp = Q.pop()
    let (d, p) = (dp.d, dp.p)
    when UseTable:
      if p in vis: continue
      vis.incl p
    else:
      if vis[p]: continue
      vis[p] = true
    for dp2 in g.adj(d, p):
      let (d2, p2) = dp2
      set_push(d2, p2)

  return dist
# }}}

var ans = int.inf

for i in 0..<N:
  if palindrome(i, 0):
    ans.min=C[i]

#type GraphIterative[P, Weight; dim:static[array]] = object
type GraphIterative[P, Weight] = object

iterator adj[G:GraphIterative](g:G, d:int, p:G.P):(g.Weight, g.P) =
  let (t, i, j) = p
  if t == 0:
    if palindrome(i, j): ans.min=d
    for p in 0..<N:
      if not forward(i, j, p): continue
      let m = min(S[i].len - j, S[p].len)
      if j + m < S[i].len:
        yield (d + C[p], (0, i, j + m))
      elif m < S[p].len:
        yield (d + C[p], (1, p, S[p].len - 1 - m))
      else:
        assert m == S[p].len and j + m == S[i].len
        ans.min= d + C[p]
  elif t == 1:
    if rpalindrome(i, j): ans.min=d
    for p in 0..<N:
      if not backward(i, j, p): continue
      let m = min(j + 1, S[p].len)
      if j - m >= 0:
        yield (d + C[p], (1, i, j - m))
      elif m < S[p].len:
        yield (d + C[p], (0, p, m))
      else:
        assert j - m == -1 and m == S[p].len
        ans.min= d + C[p]
  else: # t == 2
    for i in 0..<N:
      yield (d + C[i], (0, i, 0))

proc main() =
#  var g = GraphIterative[tuple[t, i, j:int], int, [3, 50, 22]]()
  var g = GraphIterative[tuple[t, i, j:int], int]()
  let d = g.dijkstra((2, 0, 0))
  if ans == int.inf:
    print -1
  else:
    print ans
  return

type ST = object
  a, b, c:int

proc test() =
  var a = ST(a:3, b:4, c:5)
  echo $cast[int](a.addr)
  var b = move(a)
#  echo $cast[int](a.addr)
  echo $cast[int](b.addr)

main()
#test()
