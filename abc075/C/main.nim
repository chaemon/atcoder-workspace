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
var M:int
var a:seq[int]
var b:seq[int]


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

# LowLink {{{
proc LowLink(g:Graph[int]):tuple[articulation:seq[int], bridge:seq[(int,int)]] =
  var
    used = newSeq[bool](g.len)
    ord = newSeq[int](g.len)
    low = newSeq[int](g.len)
    bridge = newSeq[(int,int)]()
    articulation = newSeq[int]()
  proc dfs(idx, k, par:int):int =
    var k = k
    used[idx] = true
    ord[idx] = k
    k += 1
    low[idx] = ord[idx]
    var
      is_articulation = false
      cnt = 0
    for e in g[idx]:
      if not used[e.dst]:
        cnt += 1
        k = dfs(e.dst, k, idx)
        low[idx] = min(low[idx], low[e.dst]);
        is_articulation = (is_articulation or (par != -1 and low[e.dst] >= ord[idx]))
        if ord[idx] < low[e.dst]: bridge.add((min(idx, e.dst), max(idx, e.dst)))
      elif e.dst != par:
        low[idx] = min(low[idx], ord[e.dst]);
    is_articulation = (is_articulation or (par == -1) and cnt > 1)
    if is_articulation: articulation.add(idx)
    return k

  var k = 0
  for i in 0..<g.len:
    if not used[i]: k = dfs(i, k, -1)
  return (articulation, bridge)
#}}}

proc solve() =
  g := initGraph[int](N)
  for i in 0..<M:
    g.addBiEdge(a[i], b[i])
  echo LowLink(g)[1].len
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(M, 0)
  b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve()
#}}}
