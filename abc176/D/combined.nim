# header {{{
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
  import streams
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  #proc getchar(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(): int = scanf("%lld",addr result)
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*[F](f:F): string =
    var get = false
    result = ""
    while true:
  #    let c = getchar()
      let c = f.readChar
      if c.int > ' '.int:
        get = true
        result.add(c)
      elif get: return
  proc nextInt*[F](f:F): int = parseInt(f.nextString)
  proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
  proc nextString*():string = stdin.nextString()
  
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  
  proc discardableId*[T](x: T): T {.discardable.} =
    return x
  
  macro `:=`*(x, y: untyped): untyped =
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
  
  
  proc toStr*[T](v:T):string =
    proc `$`[T](v:seq[T]):string =
      v.mapIt($it).join(" ")
    return $v
  
  proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
    result = ""
    for i,v in x:
      if i != 0: addSep(result, sep = sep)
      add(result, v)
    result.add("\n")
    stdout.write result
  
  var print*:proc(x: varargs[string, toStr])
  print = proc(x: varargs[string, toStr]) =
    discard print0(@x, sep = " ")
  
  template makeSeq*(x:int; init):auto =
    when init is typedesc: newSeq[init](x)
    else: newSeqWith(x, init)
  
  macro Seq*(lens: varargs[int]; init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
    parseStmt(fmt"""  
block:
  {a}""")
  
  template makeArray*(x:int; init):auto =
    var v:array[x, init.type]
    when init isnot typedesc:
      for a in v.mitems: a = init
    v
  
  macro Array*(lens: varargs[typed], init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0):
      a = fmt"makeArray({lens[i].repr}, {a})"
    parseStmt(fmt"""
block:
  {a}""")
# }}}

# header {{{
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
  import streams
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  #proc getchar(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(): int = scanf("%lld",addr result)
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*[F](f:F): string =
    var get = false
    result = ""
    while true:
  #    let c = getchar()
      let c = f.readChar
      if c.int > ' '.int:
        get = true
        result.add(c)
      elif get: return
  proc nextInt*[F](f:F): int = parseInt(f.nextString)
  proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
  proc nextString*():string = stdin.nextString()
  
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  
  proc discardableId*[T](x: T): T {.discardable.} =
    return x
  
  macro `:=`*(x, y: untyped): untyped =
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
  
  
  proc toStr*[T](v:T):string =
    proc `$`[T](v:seq[T]):string =
      v.mapIt($it).join(" ")
    return $v
  
  proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
    result = ""
    for i,v in x:
      if i != 0: addSep(result, sep = sep)
      add(result, v)
    result.add("\n")
    stdout.write result
  
  var print*:proc(x: varargs[string, toStr])
  print = proc(x: varargs[string, toStr]) =
    discard print0(@x, sep = " ")
  
  template makeSeq*(x:int; init):auto =
    when init is typedesc: newSeq[init](x)
    else: newSeqWith(x, init)
  
  macro Seq*(lens: varargs[int]; init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
    parseStmt(fmt"""  
block:
  {a}""")
  
  template makeArray*(x:int; init):auto =
    var v:array[x, init.type]
    when init isnot typedesc:
      for a in v.mitems: a = init
    v
  
  macro Array*(lens: varargs[typed], init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0):
      a = fmt"makeArray({lens[i].repr}, {a})"
    parseStmt(fmt"""
block:
  {a}""")
# }}}

let H, W = nextInt()
let Ch, Cw, Dh, Dw = nextInt() - 1
let S = newSeqWith(H, nextString())

let dir:array[4, tuple[x,y:int]] = [(0,1),(1,0),(0,-1),(-1,0)]

# multi_dimensional_dijkustra {{{
when not declared ATCODER_DIJKSTRA_MULTI_DIMENSIONAL:
  const ATCODER_DIJKSTRA_MULTI_DIMENSIONAL* = 1

  # {{{ heapqueue
  when not declared ATCODER_INTERNAL_HEAPQUEUE:
    const ATCODER_INTERNAL_HEAPQUEUE* = 1
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
    discard
  import std/strformat
  import std/macros

  macro TupleSeq*(lens: tuple; init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0): a = fmt"newSeqWith({lens.repr}[{i.repr}], {a})"
    parseStmt(a)

  macro `[]`(a: untyped, p: tuple): untyped =
    var strBody = fmt"{a.repr}"
    for i, _ in p.getTypeImpl: strBody &= fmt"[{p.repr}[{i}]]"
    parseStmt(strBody)
  macro `[]=`(a: untyped, p: tuple, x: untyped): untyped =
    var strBody = fmt"{a.repr}"
    for i, _ in p.getTypeImpl: strBody &= fmt"[{p.repr}[{i}]]"
    strBody &= fmt" = {x.repr}"
    parseStmt(strBody)

  type GraphIterativeC = concept g, type G
    type W = G.Weight
    type P = G.P
    var x:P
    for p in adj(g, 1, x):
      discard

  type HasDim = concept g
    g.dim

  proc dijkstra*[G:GraphIterativeC](g:G, s:g.P or openArray[g.P], limit = G.Weight.inf):auto =
    when g is HasDim:
      const UseArray = true
    else:
      const UseArray = false
    type P = g.P
    type Weight = g.Weight

    type DP = object
      d:int
      p:P

    proc heapCmp(a, b:DP):bool = a.d < b.d

    when UseArray:
      var
        vis = TupleSeq(g.dim, false)
        dist = TupleSeq(g.dim, limit)
    else:
      var
        vis = initSet[P]()
        dist = initTable[P, Weight]()

    var Q = initHeapQueue(heapCmp)

    proc set_push(d:int, p:P) =
      when UseArray:
        if vis[p]: return
      else:
        if p in vis: return
        if p notin dist: dist[p] = limit
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
      when UseArray:
        if vis[p]: continue
        vis[p] = true
      else:
        if p in vis: continue
        vis.incl p
      for dp2 in g.adj(d, p):
        let (d2, p2) = dp2
        set_push(d2, p2)

    return dist
# }}}



type GraphIterative[P, Weight] = object
  discard
#  dim:P

var t:array = [3, 4, 5]

type P = (int,int)
#var g = GraphIterative[P, int](dim:(H, W))
var g = GraphIterative[P, int]()

iterator adj(g:g.type, d:int, p:P):(int, P) =
  let (x, y) = p
  for di in 0..<4:
    let (x, y) = (x + dir[di].x, y + dir[di].y)
    if x notin 0..<H or y notin 0..<W or S[x][y] == '#': continue
    yield (d, (x, y))
  for i in -2..2:
    for j in -2..2:
      let (x, y) = (x + i, y + j)
      if x notin 0..<H or y notin 0..<W or S[x][y] == '#': continue
      yield (d + 1, (x, y))

block:
  let dist = g.dijkstra((Ch, Cw))
#  let d = dist[Dh][Dw]
  if (Dh, Dw) notin dist:
    print -1;break
  let d = dist[(Dh, Dw)]
  if d == int.inf:
    print -1
  else:
    print d
