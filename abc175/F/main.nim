# header {{{
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, strformat, sugar
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

# Graph {{{
when not defined ATCODER_GRAPH_TEMPLATE_HPP:
  const ATCODER_GRAPH_TEMPLATE_HPP = 1
  import sequtils
  
  type
    Edge*[T] = object
      src,dst:int
      weight:T
      rev:int
    Edges*[T] = seq[Edge[T]]
    Graph*[T] = seq[seq[Edge[T]]]
    Matrix*[T] = seq[seq[T]]
  
  proc initEdge*[T](src,dst:int,weight:T = 1,rev:int = -1):Edge[T] =
    var e:Edge[T]
    e.src = src
    e.dst = dst
    e.weight = weight
    e.rev = rev
    return e
  
  proc initGraph*[T](n:int):Graph[T] =
    return newSeqWith(n,newSeq[Edge[T]]())
  
  proc addBiEdge*[T](g:var Graph[T],e:Edge[T]):void =
    var e_rev = e
    swap(e_rev.src, e_rev.dst)
    let (r, s) = (g[e.src].len, g[e.dst].len)
    g[e.src].add(e)
    g[e.dst].add(e_rev)
    g[e.src][^1].rev = s
    g[e.dst][^1].rev = r
  proc addBiEdge*[T](g:var Graph[T],src,dst:int,weight:T = 1):void =
    g.addBiEdge(initEdge(src, dst, weight))
  
  proc initUndirectedGraph*[T](n:int, a,b,c:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
  proc initUndirectedGraph*[T](n:int, a,b:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addBiEdge(a[i], b[i])
  proc initGraph*[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
  proc initGraph*[T](n:int, a,b:seq[int]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addEdge(a[i], b[i])
  
  
  proc addEdge*[T](g:var Graph[T],e:Edge[T]):void =
    g[e.src].add(e)
  proc addEdge*[T](g:var Graph[T],src,dst:int,weight:T = 1):void =
    g.addEdge(initEdge(src, dst, weight, -1))
  
  proc `<`*[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

var N:int
var S:seq[string]
var C:seq[int]

# input part {{{
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

import atcoder/extra/graph/dijkstra_multi_dimensional

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

block:
#  var g = GraphIterative[tuple[t, i, j:int], int, [3, 50, 22]]()
  var g = GraphIterative[tuple[t, i, j:int], int]()
  let d = g.dijkstra((2, 0, 0))
  if ans == int.inf:
    print -1
  else:
    print ans

