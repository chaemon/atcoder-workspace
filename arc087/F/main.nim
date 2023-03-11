#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int=
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
#  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

proc reduce_consective[T](v:seq[T]): seq[(T,int)] =
  result = newSeq[(T,int)]()
  var i = 0
  while i < v.len:
    var j = i
    while j < v.len and v[i] == v[j]: j += 1
    result.add((v[i], j - i))
    i = j
  discard

let MOD = 1000000007

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

#{{{ Mint
type Mint = object
  v:int
proc initMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
proc init[T](self:Mint, a:T):Mint = initMint(a)
proc initMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.v += initMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= initMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= initMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
proc pow(x:Mint, n:int):Mint =
  var (x,n) = (x,n)
  result = initMint(1)
  while n > 0:
    if (n and 1) > 0: result *= x
    x *= x
    n = (n shr 1)
proc inverse(x:Mint):Mint =
  var
    (a, b) = (x.v, MOD)
    (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b; u -= t * v
    swap(a, b)
    swap(u, v)
  return initMint(u)

proc `/=`[T](a:var Mint,b:T):void =
  a *= initMint(b).inverse()
proc `/`[T](a:Mint,b:T):Mint =
  var c = a
  c /= b
  return c
#}}}

import sequtils

type Combination[T] = object
  sz:int
  fact_a, rfact_a, inv_a:seq[T]

proc initCombination[T](sz = 1):Combination[T] = 
  var
    fact_a = newSeqWith(sz + 1, T())
    rfact_a = newSeqWith(sz + 1, T())
    inv_a = newSeqWith(sz + 1, T())
  fact_a[0] = T().init(1)
  rfact_a[sz] = T().init(1)
  inv_a[0] = T().init(1)
  for i in 1..sz:fact_a[i] = fact_a[i-1] * i
  rfact_a[sz] /= fact_a[sz];
  for i in countdown(sz - 1, 0): rfact_a[i] = rfact_a[i + 1] * (i + 1)
  for i in 1..sz: inv_a[i] = rfact_a[i] * fact_a[i - 1]
  return Combination[T](sz:sz, fact_a:fact_a, rfact_a:rfact_a,inv_a:inv_a)

proc fact[T](self:var Combination[T], k:int):T =
  while self.sz < k:self = initCombination[T](self.sz*2)
  return self.fact_a[k]
proc rfact[T](self:var Combination[T], k:int):T =
  while self.sz < k:self = initCombination[T](self.sz*2)
  self.rfact_a[k]
proc inv[T](self:var Combination[T], k:int):T =
  while self.sz < k:self = initCombination[T](self.sz*2)
  self.inv_a[k]

proc P[T](self:var Combination[T], n,r:int):T =
  if r < 0 or n < r: return T()
  return self.fact(n) * self.rfact(n - r)

proc C[T](self:var Combination[T], p,q:int):T =
  if q < 0 or p < q: return T()
  return self.fact(p) * self.rfact(q) * self.rfact(p - q)

proc H[T](self:var Combination[T], n,r:int):T =
  if n < 0 or r < 0: return T()
  return if r == 0: T().init(1) else: self.C(n + r - 1, r)

var cb = initCombination[Mint]()

proc solve(N:int, x:seq[int], y:seq[int]) =
  proc calc(a:seq[int]):Mint = 
    var dp = newSeqWith(N+1, 2, 2, initMint(0))
    dp[0][0][0] = initMint(1)
    for d in a:
      var dp_to = newSeqWith(N+1, 2, 2, initMint(0))
      for t in 0..N:
        for get in 0..1:
          for put in 0..1:

      swap(dp, dp_to)
    discard

  var
    G = initGraph[int](N)
    ans = initMint(1)
    size = newSeq[int](N)
  for i in 0..<N-1: G.addBiEdge(x[i],y[i])
  proc dfs(u,p:int) =
    size[u] = 1
    var
      v = newSeq[int]()
    for e in G[u]:
      if e.dst == p: continue
      dfs(e.dst,u)
      v.add(min(size[e.dst],N - size[e.dst]))
      size[u] += size[e.dst]
    if p >= 0: v.add(min(size[u], N - size[u]))
    ans *= calc(v)
  dfs(0,-1)
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var x = newSeqWith(N-1, 0)
  var y = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt(1)
    y[i] = nextInt(1)
  solve(N, x, y);
  return

main()
#}}}
