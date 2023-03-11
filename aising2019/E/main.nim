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
var A:seq[int]
var U:seq[int]
var V:seq[int]


#{{{ input part
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
  U = newSeqWith(N-1, 0)
  V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
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

g := initGraph[int](N)

for i in 0..<N - 1: g.addBiEdge(U[i], V[i])

proc merge(a,b:seq[int], n:int):seq[int] =
  result = newSeqWith(a.len + b.len, int.inf)
  # cut b
  var t = 0
  while t < b.len:
    if b[t] < 0: break
    t += 1
  if t < b.len:
    for i in 0..<a.len:
      result[i + t + 1].min=a[i]
  if n != int.inf:
    for i in 0..<a.len:
      result[i + n + 1].min=a[i]
  # not cut b
  for i in 0..<a.len:
    for j in 0..<b.len:
      result[i + j].min=a[i] + b[j]
  for i in 0..<result.len - 1:
    result[i + 1].min=result[i]

proc dfs(u:int, p = -1):(seq[int], int) =
  v := newSeq[int](1)
  var n: int
  if A[u] > 0:
    n = 0
  else:
    n = int.inf
  v[0] = A[u]
  for e in g[u]:
    if e.dst == p: continue
    var (v2, n2) = dfs(e.dst, u)
    v = merge(v, v2, n2)
    if n < int.inf:
      # cut
      var t = 0
      while t < v2.len:
        if v2[t] < 0: break
        t += 1
      if t == v2.len: t = int.inf
      else: t += 1
      if n2 != int.inf: t.min=n2
      if t != int.inf: n += t
  return (v, n)

let (v, n) = dfs(0)

ans := int.inf
for i in 0..<v.len:
  if v[i] < 0: ans.min= i
ans.min=n

echo ans
