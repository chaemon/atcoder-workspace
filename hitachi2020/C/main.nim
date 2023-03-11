#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
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
#}}}

var N:int
var a:seq[int]
var b:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  a = newSeqWith(N-1, 0)
  b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
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

color := newSeq[int](N)

# depth first search {{{
proc dfs[T](g:Graph[T], u:int, p = -1, col = 0) =
  color[u] = col
  for e in g[u]:
    if e.dst == p: continue
    g.dfs(e.dst, u, 1 - col)
#}}}

proc main() =
  g := initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(a[i], b[i])
  g.dfs(0)
  ct0 := 0
  ct1 := 0
  for i in 0..<N:
    if color[i] == 0: ct0+=1
    else: ct1 += 1
  if ct0 > ct1:
    for i in 0..<N:color[i] = 1 - color[i]
    swap(ct0, ct1)
  # ct0 < ct1
  var N0, N1, N2 = N div 3
  let r = N mod 3
  if r >= 1: N1 += 1
  if r >= 2: N2 += 1
  var P = newSeqWith(N, -1)
  # N0 <= N2 <= N1
  if ct0 >= N1:
    # 0 to N1, 1 to N2
    block:
      var t = 1
      for u in 0..<N:
        if color[u] == 0 and t <= N:
          P[u] = t
          t += 3
    block:
      var t = 2
      for u in 0..<N:
        if color[u] == 1 and t <= N:
          P[u] = t
          t += 3
    block:
      var t = 3
      for u in 0..<N:
        if P[u] == -1: P[u] = t;t += 3
  elif ct0 <= N0:
    # 0 to N0
    block:
      var t = 3
      for u in 0..<N:
        if color[u] == 0 and t <= N:
          P[u] = t;t += 3
      for u in 0..<N:
        if P[u] == -1 and t <= N:
          P[u] = t
          t += 3
    block:
      var t = 1
      for u in 0..<N:
        if P[u] == -1 and t <= N:
          P[u] = t
          t += 3
    block:
      var t = 2
      for u in 0..<N:
        if P[u] == -1 and t <= N:
          P[u] = t
          t += 3
  print P.mapIt($it).join(" ")
  return

main()
