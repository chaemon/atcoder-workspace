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
var A:seq[int]
var B:seq[int]
var L:seq[int]
var R:seq[int]

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  L = newSeqWith(M, 0)
  R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
#}}}

v := newSeq[(int,int)]()

for i in 0..<N: v.add((A[i], B[i]))
v.sort()

for i in 0..<N: A[i] = v[i][0]; B[i] = v[i][1]

for i in 0..<M:
  L[i] = A.lowerBound(L[i])
  R[i] = A.lowerBound(R[i] + 1)

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

g := initGraph[int](N+1)

proc calc_initial_type(i:int) :int =
  var a, b:int
  if i == 0:
    a = 0
    b = B[i]
  elif i == N:
    a = B[i-1]
    b = 0
  else:
    a = B[i-1]
    b = B[i]
  if a == b: return 0
  else: return 1

s := newSeqWith(N+1, 0)

for i in 0..N:
  s[i] = calc_initial_type(i)

for i in 0..<M:
  # L[i] - 1, L[i]
  # R[i] - 1, R[i]
  if L[i] >= R[i]: continue
  g.addBiEdge(L[i], R[i], i)

ans := newSeqWith(M, 0)
vis := newSeqWith(N + 1, false)

proc dfs(u:int, p = -1):int =
  result = s[u]
  vis[u] = true
  for e in g[u]:
    if e.dst == p: continue
    if vis[e.dst]: continue
    d := dfs(e.dst, u)
    if d mod 2 == 1:
      ans[e.weight] = 1
    result += d

valid := true

for u in 0..N:
  if vis[u]: continue
  d := dfs(u)
  if d mod 2 != 0: valid = false;break

if not valid:
  echo -1
else:
  echo ans.sum
  for i,a in ans:
    if a == 1:
      stdout.write i + 1, " "
  echo ""


