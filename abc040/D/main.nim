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
var y:seq[int]
var Q:int
var v:seq[int]
var w:seq[int]

#{{{ Union-Find
type UnionFind = object
  data:seq[int]

proc initUnionFind(size:int):UnionFind =
  var uf:UnionFind
  uf.data = newSeqWith(size,-1)
  return uf

proc compress(uf:var UnionFind,x:int,r:var int):void =
  if uf.data[x]<0:
    r = x
    return
  uf.compress(uf.data[x],r)
  uf.data[x] = r;

proc root(uf:var UnionFind, x:int):int =
  var r:int
  uf.compress(x,r)
  return r;

proc size(uf:var UnionFind, x:int):int =
  return -uf.data[uf.root(x)]

proc unionSet(uf:var UnionFind, x,y:int):bool{.discardable.} =
  var
    rx = uf.root(x)
    ry = uf.root(y)
  if rx == ry: return false
  if uf.data[ry] < uf.data[rx]:
    swap(rx, ry)
  uf.data[rx] += uf.data[ry]
  uf.data[ry] = rx
  return true

proc findSet(uf:var UnionFind, x,y:int):bool =
  return uf.root(x) != uf.root(y)
#}}}

proc solve() =
  ans := newSeq[int](Q)
  q := newSeq[(int,int,int)]() # year, city, index
  for i in 0..<Q:
    q.add((w[i], v[i], i))
  q.sort()
  q.reverse()
  qi := 0
  p := newSeq[(int,int,int)]() # year, src, dst
  for i in 0..<M:
    p.add((y[i], a[i], b[i]))
  p.sort()
  p.reverse()
  pi := 0
  uf := initUnionFind(N)
  for q in q:
    let (w,v,i) = q
#    echo w, " ", v, " ", i
    while pi < M and p[pi][0] > w:
      let (y,a,b) = p[pi]
#      echo "  ", y, " ", a, " ", b
      uf.unionSet(a,b)
      pi.inc
    ans[i] = uf.size(v)
  for a in ans:
    echo a
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(M, 0)
  b = newSeqWith(M, 0)
  y = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    y[i] = nextInt()
  Q = nextInt()
  v = newSeqWith(Q, 0)
  w = newSeqWith(Q, 0)
  for i in 0..<Q:
    v[i] = nextInt() - 1
    w[i] = nextInt()
  solve()
#}}}
