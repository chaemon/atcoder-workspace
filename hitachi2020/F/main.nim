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

const MOD = 998244353
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

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v *= initModInt(a, Mod).v
  self.v = self.v mod MOD
proc `^=`(self:var ModInt[Mod], n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse(x:int):ModInt[Mod] =
  var (a, b) = (x, MOD)
  var (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u, Mod)
proc `/=`[T](a:var ModInt[Mod],b:T):void = a *= initModInt(b, Mod).v.inverse()
proc `+`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result += b
proc `-`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result -= b
proc `*`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result *= b
proc `/`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a; result /= b
proc `^`(a:ModInt[Mod],b:int):ModInt[Mod] = result = a; result ^= b
#}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)

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

proc initUndirectedGraph[T](n:int, a,b,c:seq[T]):Graph[T] =
  var result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], T(1))
proc initGraph[T](n:int, a,b,c:seq[T]):Graph[T] =
  var result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], T(1))


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

var p1:int

proc treeDiameter[T](g:Graph[T]):int =
  proc dfs(idx, par:int):(T,int) =
    result[1] = idx
    for e in g[idx]:
      if e.dst == par: continue
      var cost = dfs(e.dst, idx)
      cost[0] += e.weight
      result = max(result, cost)
  let
    p = dfs(0, -1)
    q = dfs(p[1], -1)
  p1 = p[1]
  return q[0]

# depth first search {{{
var v = newSeq[int]()
proc dfs0[T](g:Graph[T], u:int, p:int, h:int):bool =
  if h == 0: return true
  for e in g[u]:
    if e.dst == p: continue
    v.add(e.dst)
    if g.dfs0(e.dst, u, h - 1): return true
    discard v.pop()
  return false
#}}}

var max_depth = newSeq[int](N)
var size = newSeq[int](N)

proc dfs1[T](g:Graph[T], u:int, p = -1, depth = 0):void =
  max_depth[u] = depth
  size[u] = 1
  for e in g[u]:
    if e.dst == p: continue
    g.dfs1(e.dst, u, depth + 1)
    max_depth[u] .max= max_depth[e.dst]
    size[u] += size[e.dst]

var target_depth:int

proc dfs2[T](g:Graph[T], u:int, p = -1, depth = 0):(Mint,Mint) =
  if depth == target_depth: return (initMint(0), initMint(1))
  result = (initMint(1), initMint(0))
  for e in g[u]:
    if e.dst == p: continue
    let a = g.dfs2(e.dst, u, depth + 1)
    if max_depth[e.dst] == target_depth:
      var result2:(Mint,Mint)
      # make e critical
      result2[0] += result[0] * a[0]
#      result2[1] += result[1] * t + result[0] * (t - a[0])
      result2[1] += result[0] * a[1] + result[1] * a[0]
      # make e non critical
      let d = initMint(2) * initMint(3)^(size[e.dst] - 1)
      result2[0] += result[0] * d
      result2[1] += result[1] * d
      swap(result, result2)
    else:
      # always non critical
      let d = initMint(3)^size[e.dst]
      result[0] *= d
      result[1] *= d

proc main() =
  g := initUndirectedGraph[int](N, a, b)
  let d = g.treeDiameter
  v.add(p1)
  discard g.dfs0(p1, -1, d)
  target_depth = d div 2
  if d mod 2 == 0:
    let c = v[d div 2]
    g.dfs1(c)
    dp := newSeq[Mint](3)
    dp[0] = initMint(1)
    for e in g[c]:
      let v0 = g.dfs2(e.dst, c, 1)
      if max_depth[e.dst] < target_depth:
        for b in 0..<dp.len: dp[b] *= initMint(3) * v0[0]
      else:
        dp2 := newSeq[Mint](3)
        for b in 0..<dp.len:
          # make e critical
          if b < 2:
            dp2[b + 1] += dp[b] * v0[1]
          dp2[b] += dp[b] * v0[0]
          # make e non critical
          dp2[b] += dp[b] * initMint(2) * initMint(3)^(size[e.dst] - 1)
        swap(dp, dp2)
    echo dp[2]
  else:
    let
      c0 = v[d div 2]
      c1 = v[d div 2 + 1]
    g.dfs1(c0, c1)
    g.dfs1(c1, c0)
    let
      v0 = g.dfs2(c0, c1)
      v1 = g.dfs2(c1, c0)
    echo v0[1] * v1[1]
  return

main()
