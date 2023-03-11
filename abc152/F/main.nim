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

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = int(b shr B(n)) mod 2
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (1 shl (s.b - s.a + 1))
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#}}}

#{{{ bitset
import strutils, sequtils, algorithm

let BitWidth = 64

proc toBin(b:uint64, n: int): string =
  result = ""
  for i in countdown(n-1, 0):
    if (b and (1.uint64 shl i.uint64)) != 0.uint64: result &= "1"
    else: result &= "0"

type BitSet = object
  len: int
  data: seq[uint64]


proc initBitSet(n: int): BitSet =
  var q = (n + BitWidth - 1) div BitWidth
  return BitSet(len:n, data: newSeq[uint64](q))
proc initBitSet1(n: int): BitSet =
  var
    q = n div BitWidth
    r = n mod BitWidth
  result = BitSet(len:n, data: newSeq[uint64]())
  for i in 0..<q:result.data.add(not 0'u64)
  if r > 0:result.data.add((1'u64 shl uint64(r)) - 1)

proc `not`(a: BitSet): BitSet =
  result = initBitSet1(a.len)
  for i in 0..<a.data.len: result.data[i] = (not a.data[i]) and result.data[i]
proc `or`(a, b: BitSet): BitSet =
  assert(a.len == b.len)
  result = initBitSet(a.len)
  for i in 0..<a.data.len: result.data[i] = a.data[i] or b.data[i]
proc `and`(a, b: BitSet): BitSet =
  assert(a.len == b.len)
  result = initBitSet(a.len)
  for i in 0..<a.data.len: result.data[i] = a.data[i] and b.data[i]
proc `xor`(a, b: BitSet): BitSet =
  assert(a.len == b.len)
  result = initBitSet(a.len)
  for i in 0..<a.data.len: result.data[i] = a.data[i] xor b.data[i]

proc `$`(a: BitSet):string =
  var
    q = a.len div BitWidth
    r = a.len mod BitWidth
  var v = newSeq[string]()
  for i in 0..<q:
    v.add(a.data[i].toBin(BitWidth))
  if r > 0:
    v.add(a.data[q].toBin(r))
  v.reverse()
  return v.join("")

proc `[]`(b:BitSet,n:int):int =
  assert 0 <= n and n < b.len
  let
    q = n div BitWidth
    r = n mod BitWidth
  return b.data[q][r]
proc `[]=`(b:var BitSet,n:int,t:int) =
  assert 0 <= n and n < b.len
  assert t == 0 or t == 1
  let
    q = n div BitWidth
    r = n mod BitWidth
  b.data[q][r] = t

proc `shl`(a: BitSet, n:int): BitSet =
  result = initBitSet(a.len)
  var r = n mod BitWidth
  if r < 0: r += BitWidth
  let q = (n - r) div BitWidth
  let maskl = setBits[uint64](BitWidth - r)
  for i in 0..<a.data.len:
    let d = (a.data[i] and maskl) shl uint64(r)
    let i2 = i + q
    if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  if r != 0:
    let maskr = setBits[uint64](r) shl (BitWidth - r).uint64
    for i in 0..<a.data.len:
      let d = (a.data[i] and maskr) shr uint64(BitWidth - r)
      let i2 = i + q + 1
      if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  block:
    let r = a.len mod BitWidth
    if r != 0:
      let mask = not (setBits[uint64](BitWidth - r) shl uint64(r))
      result.data[^1] = result.data[^1] and mask
proc `shr`(a: BitSet, n:int): BitSet = a shl (-n)
#}}}

# tree dfs {{{
type TreeDFS[T] = object
  depth, parent, size, dist:seq[int]

proc initTreeDFS[T](g:Graph[T], r = 0):TreeDFS[T] =
  var depth = newSeqWith(g.len, 0)
  var parent = newSeqWith(g.len, 0)
  var size = newSeqWith(g.len, 0)
  var dist = newSeqWith(g.len, 0)

  proc dfs(idx, par, dep, d:int) =
    depth[idx] = d
    parent[idx] = par
    dist[idx] = d
    for e in g[idx]:
      if e.dst != par:
        dfs(e.dst, idx, dep + 1, d + e.weight)
        size[idx] += size[e.dst]
  dfs(r, -1, 0, 0)

  return TreeDFS[T](depth:depth, parent:parent, size:size, dist:dist)
# }}}

var N:int
var a:seq[int]
var b:seq[int]
var M:int
var u:seq[int]
var v:seq[int]

proc solve() =
  var g = initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(a[i], b[i])
  var t = g.initTreeDFS(N-1)
  b := newSeq[BitSet]()
  for i in 0..<M:
    var bs = initBitSet(N-1)
    var (u,v) = (u[i], v[i])
    while t.depth[u] != t.depth[v] or u != v:
      if t.depth[u] != t.depth[v]:
        if t.depth[u] < t.depth[v]:
          bs[v] = 1
          v = t.parent[v]
        else:
          bs[u] = 1
          u = t.parent[u]
      else:
        bs[u] = 1
        u = t.parent[u]
        bs[v] = 1
        v = t.parent[v]
    b.add(bs)
  ans := 0
  for bit in 0..<(1 shl M):
    ct := 0
    bsum := initBitSet(N-1)
    for i in 0..<M:
      if bit[i] == 1:
        ct += 1
        bsum = bsum or b[i]
    C := 0
    for i in 0..<N-1:
      if bsum[i] == 1: C += 1
    if ct mod 2 == 0:
      ans += 2 ^ (N - 1 - C)
    else:
      ans -= 2 ^ (N - 1 - C)
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  a = newSeqWith(N-1, 0)
  b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  M = nextInt()
  u = newSeqWith(M, 0)
  v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve()
#}}}
