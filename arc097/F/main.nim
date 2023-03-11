# header {{{
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, strformat, sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
    let c = getchar()
#    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
#proc nextInt[F](f:F): int = parseInt(f.nextString)
#proc nextFloat[F](f:F): float = parseFloat(f.nextString)
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
  parseStmt(a)

template makeArray(x; init):auto =
  when init is typedesc:
    var v:array[x, init]
  else:
    var v:array[x, init.type]
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(a)
#}}}

var N = nextInt()
var
  x = newSeq[int](N - 1)
  y = newSeq[int](N - 1)
  state = newSeq[int](N)
for i in 0..<N-1:
  x[i] = nextInt() - 1
  y[i] = nextInt() - 1
let c = newSeqWith(N, if getChar() == 'B': 0 else: 1)

# Graph {{{
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]
  Matrix[T] = seq[seq[T]]

proc initEdge[T](src,dst:int,weight:T = 1,rev:int = -1):Edge[T] =
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
proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T = 1):void =
  g.addBiEdge(initEdge(src, dst, weight))

proc initUndirectedGraph[T](n:int, a,b,c:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i])
proc initGraph[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[int]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i])


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T = 1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

# treeDiameter(g:Graph[T]) {{{
proc treeDiameter[T](g:Graph[T]):(T, seq[int]) =
  var next = newSeq[int](g.len)
  proc dfs(idx, par:int):(T,int) =
    result[1] = idx
    for i,e in g[idx]:
      if e.dst == par: continue
      var cost = dfs(e.dst, idx)
#      cost[0] += e.weight
      cost[0] += c[e.src]
      if result[0] < cost[0]:
        next[idx] = i
        result = cost
#      result = max(result, cost)
  let p = dfs(0, -1)
  next = newSeqWith(g.len, -1)
  let q = dfs(p[1], -1)
  var
    ans = newSeq[int]()
    u = p[1]
  while true:
    ans.add(u)
    let idx = next[u]
    if idx == -1:break
    u = g[u][idx].dst
  return (q[0], ans)
# }}}

# depth first search {{{
proc dfs[T](g:Graph[T], u:int, p = -1):(int,bool) =
  result[0] = 1
  result[1] = true
  if c[u] == 1:
    result = (1, false)
  else:
    result = (0, true)
  for e in g[u]:
    if e.dst == p: continue
    let (n, b) = g.dfs(e.dst, u)
    if not b: result[1] = false
    result[0] += n
  if result[1]:
    state[u] = 0
  else:
    state[u] = 1
#}}}

proc main() =
  var g = initGraph[int](N)
  for i in 0..<N-1:
    g.addBiEdge(x[i], y[i])
  let r = c.find(1)
  if r == -1:
    print 0
    return
  let (n, all_black) = g.dfs(r)
  dump(state)
  var ans = 2 * (n - 1)
  for u in 0..<N:
    var t = c[u]
    for e in g[u]:
      if state[e.dst] == 1:
        t.inc
    if t mod 2 == 1:
      ans.inc
  dump(ans)
  dump(g.treeDiameter())
  dump(state)
  return

main()
