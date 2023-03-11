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

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
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
  v:int32
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a.int32
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0.int32: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v = ((self.v.int * initModInt(a, Mod).v.int) mod MOD).int32
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

#{{{ combination
import sequtils

proc `/`(a, b:int):int = a div b

proc fact(T:typedesc, k:int):T =
  var fact_a{.global.} = @[getDefault(T).init(1)]
  if k >= fact_a.len:
    let sz_old = fact_a.len - 1
    let sz = max(sz_old * 2, k)
    fact_a.setlen(sz + 1)
    for i in sz_old + 1..sz: fact_a[i] = fact_a[i-1] * getDefault(T).init(i)
  return fact_a[k]
proc rfact(T:typedesc, k:int):T =
  var rfact_a{.global.} = @[getDefault(T).init(1)]
  if k >= rfact_a.len:
    let sz_old = rfact_a.len - 1
    let sz = max(sz_old * 2, k)
    rfact_a.setlen(sz + 1)
    rfact_a[sz] = getDefault(T).init(1) / T.fact(sz)
    for i in countdown(sz - 1, sz_old + 1): rfact_a[i] = rfact_a[i + 1] * getDefault(T).init(i + 1)
  return rfact_a[k]

proc inv(T:typedesc, k:int):T =
  return T.fact_a(k - 1) * T.rfact(k)

proc P(T:typedesc, n,r:int):T =
  if r < 0 or n < r: return getDefault(T).init(0)
  return T.fact(n) * T.rfact(n - r)
proc C(T:typedesc, p,q:int):T =
  if q < 0 or p < q: return getDefault(T).init(0)
  return T.fact(p) * T.rfact(q) * T.rfact(p - q)
proc H(T: typedesc, n,r:int):T =
  if n < 0 or r < 0: return getDefault(T).init(0)
  return if r == 0: T(1) else: T.C(n + r - 1, r)
#}}}

#ReRooting: initReRooting[Weight, Data](n:int, f_up(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data)
# {{{
#import sequtils, future
#type
#  Node[Weight] = object
#    to, rev: int
#    data: Weight
#  ReRooting[Weight, Data] = object
#    g:seq[seq[Node[Weight]]]
#    ldp, rdp: seq[seq[Data]]
#    lptr, rptr: seq[int]
#    ident: Data
#    f_up: (Data,Weight)->Data
#    f_merge: (Data,Data)->Data
#
#proc initNode[Weight](to, rev:int, d: Weight):Node[Weight] = Node[Weight](to: to, rev: rev, data: d)
#proc initReRooting[Weight, Data](n:int, f_up:(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data):ReRooting[Weight,Data] =
#  return ReRooting[Weight,Data](
#    g:newSeqWith(n, newSeq[Node[Weight]]()),
#    ldp:newSeqWith(n, newSeq[Data]()),
#    rdp:newSeqWith(n, newSeq[Data]()),
#    lptr:newSeq[int](n), rptr:newSeq[int](n),
#    f_up:f_up, f_merge:f_merge, ident:ident)
#
#proc addEdge[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d:Weight) =
#  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
#  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, d))
#proc addEdgeBi[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d,e:Weight) =
#  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
#  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, e))
#proc dfs[Weight, Data](self: var ReRooting[Weight, Data], idx, par:int):Data =
#  while self.lptr[idx] != par and self.lptr[idx] < self.g[idx].len:
#    var e = self.g[idx][self.lptr[idx]].addr
#    self.ldp[idx][self.lptr[idx] + 1] = self.f_merge(self.ldp[idx][self.lptr[idx]], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
#    self.lptr[idx] += 1
#  while self.rptr[idx] != par and self.rptr[idx] >= 0:
#    var e = self.g[idx][self.rptr[idx]].addr
#    self.rdp[idx][self.rptr[idx]] = self.f_merge(self.rdp[idx][self.rptr[idx] + 1], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
#    self.rptr[idx] -= 1
##  if par < 0: return self.rdp[idx][0]
##  return self.f_merge(self.ldp[idx][par], self.rdp[idx][par + 1])
#  if par < 0: result = self.rdp[idx][0]
#  else: result = self.f_merge(self.ldp[idx][par], self.rdp[idx][par + 1])
#  result[0].inc
#
#
#proc solve[Weight, Data](self: var ReRooting[Weight, Data]):seq[Data] =
#  for i in 0..<self.g.len:
#    self.ldp[i] = newSeqWith(self.g[i].len + 1, self.ident)
#    self.rdp[i] = newSeqWith(self.g[i].len + 1, self.ident)
#    self.lptr[i] = 0
#    self.rptr[i] = self.g[i].len - 1
#  result = newSeq[Data]()
#  for i in 0..<self.g.len: result.add(self.dfs(i, -1))
#}}}

#ReRooting: initReRooting[Weight, Data](n:int, f_up(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data)
# {{{
import sequtils, future
type
  Edge[Weight, Data] = object
    to: int
    weight: Weight
    dp, ndp: Data
  ReRooting[Weight, Data] = object
    g:seq[seq[Edge[Weight, Data]]]
    subdp, dp: seq[Data]
    ident: Data
    f_up: (Data,Weight)->Data
    f_merge: (Data,Data)->Data

proc initEdge[Weight, Data](to:int, d: Weight, dp, ndp: Data):Edge[Weight, Data] = Edge[Weight, Data](to: to, weight: d, dp: dp, ndp: ndp)
proc initReRooting[Weight, Data](n:int, f_up:(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data):ReRooting[Weight,Data] =
  return ReRooting[Weight,Data](
    g:newSeqWith(n, newSeq[Edge[Weight, Data]]()),
    subdp: newSeqWith(n, ident),
    dp: newSeqWith(n, ident),
    f_up:f_up, f_merge:f_merge, ident:ident)

proc addEdge[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d:Weight) =
  self.g[u].add(initEdge[Weight, Data](v, d, self.ident, self.ident))
  self.g[v].add(initEdge[Weight, Data](u, d, self.ident, self.ident))
proc addEdgeBi[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d,e:Weight) =
  self.g[u].add(initEdge[Weight, Data](v, d, self.ident, self.ident))
  self.g[v].add(initEdge[Weight, Data](u, e, self.ident, self.ident))
proc dfs_sub[Weight, Data](self: var ReRooting[Weight, Data]; idx, par:int) =
  for e in self.g[idx]:
    if e.to == par: continue
    self.dfs_sub(e.to, idx)
    self.subdp[idx] = self.f_merge(self.subdp[idx], self.f_up(self.subdp[e.to], e.weight))

proc dfs_all[Weight, Data](self: var ReRooting[Weight, Data]; idx, par:int, top:Data) =
  var buff = self.ident
  for i in 0..<self.g[idx].len:
    var e = self.g[idx][i].addr
    e[].ndp = buff
    e[].dp = self.f_up(if par == e.to: top else: self.subdp[e.to], e[].weight)
    buff = self.f_merge(buff, e[].dp)
  self.dp[idx] = buff
  buff = self.ident
  for i in countdown(self.g[idx].len - 1, 0):
    var e = self.g[idx][i].addr
    if e[].to != par:
      var tmp = self.f_merge(e[].ndp, buff)
      self.dfs_all(e[].to, idx, tmp)
    e[].ndp = self.f_merge(e[].ndp, buff)
    buff = self.f_merge(buff, e[].dp)

proc solve[Weight, Data](self: var ReRooting[Weight, Data]):seq[Data] =
  self.dfs_sub(0, -1)
  self.dfs_all(0, -1, self.ident)
  return self.dp
#}}}


proc f_up(d:(int,Mint), w:int):(int,Mint) = (d[0] + 1, d[1])
proc f_merge(d, e:(int,Mint)):(int,Mint) =
  result[0] = d[0] + e[0]
  result[1] = Mint.C(d[0] + e[0], d[0]) * d[1] * e[1]
proc f_post(d:(int,Mint)):(int,Mint) = (d[0] + 1, d[1])

proc main() =
  g := initReRooting[int,(int,Mint)](N, f_up, f_merge, (0, initMint(1)))
  for i in 0..<N-1:g.addEdgeBi(a[i], b[i], 0, 0)
  ans := g.solve()
  for p in ans:
    print p[1]
  return

main()
