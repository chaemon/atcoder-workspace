# header {{{
{.hints:off warnings:off optimization:speed experimental:"codeReordering".}
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
  parseStmt(a)

template makeArray(x; init):auto =
  when init is typedesc:
    var v:array[x, init]
  else:
    var v:array[x, init.type]
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(a)
#}}}

# dump {{{
import macros, strformat

macro dump*(n: varargs[untyped]): untyped =
  var a = "stderr.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

const MOD = 1000000007
var N:int
var x:seq[int]
var y:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  x = newSeqWith(N-1, 0)
  y = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt() - 1
    y[i] = nextInt() - 1
#}}}

# ModInt {{{
# ModInt[Mod] {{{
type ModInt[Mod: static[int]] = object
  v:int32

proc initModInt(a:SomeInteger, Mod:static[int]):ModInt[Mod] =
  var a = a.int
  a = a mod Mod
  if a < 0: a += Mod
  result.v = a.int32

macro declareModInt(Mod:static[int], t: untyped):untyped =
  var strBody = ""
  strBody &= fmt"""
type {t.repr} = ModInt[{Mod.repr}]
converter to{t.repr}(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
proc init{t.repr}(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
proc `$`(a:{t.repr}):string = $(a.v)
"""
  parseStmt(strBody)

when declared(Mod): declareModInt(Mod, Mint)
##}}}

# ModIntDynamic {{{
type DMint = object
  v:int32

proc setModSub(self:typedesc, m:int = -1, update = false):int32 {.discardable.} =
  var DMOD {.global.}:int32
  if update: DMOD = m.int32
  return DMOD

proc fastMod(a:int,m:uint32):uint32{.inline.} =
  var
    minus = false
    a = a
  if a < 0:
    minus = true
    a = -a
  elif a < m.int:
    return a.uint32
  var
    xh = (a shr 32).uint32
    xl = a.uint32
    d:uint32
  asm """
    "divl %4; \n\t"
    : "=a" (`d`), "=d" (`result`)
    : "d" (`xh`), "a" (`xl`), "r" (`m`)
  """
  if minus and result > 0'u32: result = m - result
proc initDMint(a:SomeInteger, Mod:int):DMint =
  var a = fastMod(a.int, Mod.uint32).int
  result.v = a.int32
#}}}

# Operations {{{
type ModIntC = concept x, type T
  x.v

proc getMod[T](self: T):int32 =
  when T is ModInt:
    return T.Mod
  else:
    return T.type.setModSub()
proc getMod(self: typedesc):int32 =
  when self is ModInt:
    return self.Mod
  else:
    return self.setModSub()

proc setMod(self: typedesc, m:int) =
  self.setModSub(m, true)

proc Identity(self:ModIntC):auto = result = self;result.v = 1
proc makeModInt[Mod:static[int], T](self:ModInt[Mod], a:T):ModInt[Mod] =
  when a is ModInt[Mod]:
    return a
  else:
    initModInt(a, Mod)

proc makeModInt[T](self:ModIntC and not ModInt, a:T):typeof(self) =
  when a is self.type:
    a
  else:
    (var r = self.type.default;r.v = fastMod(a.int, self.getMod().uint32).int32;r)

macro declareDMintConverter(t:untyped) =
  parseStmt(fmt"""
converter to{t.repr}(a:int):{t.repr} =
  let Mod = {t.repr}.getMod()
  if Mod > 0:
    result.v = fastMod(a.int, Mod.uint32).int32
  else:
    result.v = a.int32
    doAssert(false)
  return result
""")

declareDMintConverter(DMint)

macro declareDMint(t:untyped) =
  parseStmt(fmt"""
type {t.repr} {{.borrow: `.`.}} = distinct DMint
declareDMintConverter({t.repr})
""")

proc `*=`[T](self:var ModIntC, a:T) =
  when self is ModInt:
    self.v = (self.v.int * self.makeModInt(a).v.int mod self.getMod().int).int32
  else:
    self.v = fastMod(self.v.int * self.makeModInt(a).v.int, self.getMod().uint32).int32
proc `==`[T](a:ModIntC, b:T):bool = a.v == a.makeModInt(b).v
proc `!=`[T](a:ModIntC, b:T):bool = a.v != a.makeModInt(b).v
proc `-`(self:ModIntC):auto =
  if self.v == 0: return self
  else: return self.makeModInt(self.getMod() - self.v)
proc `$`(a:ModIntC):string = return $(a.v)

proc `+=`[T](self:var ModIntC; a:T) =
  self.v += self.makeModInt(a).v
  if self.v >= self.getMod(): self.v -= self.getMod()
proc `-=`[T](self:var ModIntC, a:T) =
  self.v -= self.makeModInt(a).v
  if self.v < 0: self.v += self.getMod()
proc `^=`(self:var ModIntC, n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse(self: ModIntC):auto =
  var
    a = self.v.int
    b = self.getMod().int
    u = 1
    v = 0
  while b > 0:
    let t = a div b
    a -= t * b;swap(a, b)
    u -= t * v;swap(u, v)
  return self.makeModInt(u)
proc `/=`[T](a:var ModIntC,b:T) =
  a *= a.makeModInt(b).inverse()
proc `+`[T](a:ModIntC,b:T):auto = result = a;result += b
proc `-`[T](a:ModIntC,b:T):auto = result = a;result -= b
proc `*`[T](a:ModIntC,b:T):auto = result = a;result *= b
proc `/`[T](a:ModIntC,b:T):auto = result = a;result /= b
proc `^`(a:ModIntC,b:int):auto = result = a;result ^= b
# }}}
# }}}

# combination {{{
import sequtils

#proc `/`(a, b:int):int = a div b

type IntC = concept x
  x + x
  x - x
  x * x
  x / x

type Combination[T] = object
  fact_a, rfact_a: seq[T]

type CombinationC = concept x
  x is typedesc[IntC] or x is var Combination

proc getVal[T:IntC](cmb: var Combination[T], t:static[int], k:int):auto {.discardable.} =
  if k >= cmb.fact_a.len:
    if cmb.fact_a.len == 0:
      cmb.fact_a = @[T(1)]
      cmb.rfact_a = @[T(1)]
    let sz_old = cmb.fact_a.len - 1
    let sz = max(sz_old * 2, k)
    cmb.fact_a.setlen(sz + 1)
    cmb.rfact_a.setlen(sz + 1)
    for i in sz_old + 1..sz: cmb.fact_a[i] = cmb.fact_a[i-1] * T(i)
    cmb.rfact_a[sz] = T(1) / cmb.fact_a[sz]
    for i in countdown(sz - 1, sz_old + 1): cmb.rfact_a[i] = cmb.rfact_a[i + 1] * T(i + 1)
  when t == 0: return cmb.fact_a[k]
  elif t == 1: return cmb.rfact_a[k]
  elif t == 2: # reset
    cmb.fact_a.setLen(0)
    cmb.rfact_a.setLen(0)
    return T(0)
template resetCombination(T:typedesc[IntC] or var Combination) = T.getVal(2, 0)

proc getVal(T:typedesc[IntC], t:static[int], k:int):auto {.discardable.} =
  var cmb{.global.} = Combination[T]()
  return cmb.getVal(t, k)

template zero(T:typedesc[IntC]):T = T(0)
template zero[T](cmb:Combination[T]):T = T(0)

template fact(T:CombinationC, k:int):auto = T.getVal(0, k)
template rfact(T:CombinationC, k:int):auto = T.getVal(1, k)
template inv(T:CombinationC, k:int):auto = T.fact_a(k - 1) * T.rfact(k)

template P(T:CombinationC, n,r:int):auto =
  if r < 0 or n < r: T.zero()
  else: T.fact(n) * T.rfact(n - r)
template C(T:CombinationC, n,r:int):auto =
  if r < 0 or n < r: T(0)
  else: T.fact(n) * T.rfact(r) * T.rfact(n - r)
template H(T:CombinationC, n,r:int):auto =
  if n < 0 or r < 0: T(0)
  elif r == 0: T(1)
  else: T.C(n + r - 1, r)
# }}}

# Graph {{{
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]
  Matrix[T] = seq[seq[T]]

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
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], T(1))
proc initGraph[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[int]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], T(1))


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

var cmb = Combination[Mint]()
#var dp = lc[cmb.fact(n * 2) / (Mint(2)^n * cmb.fact(n)) | (n <- 0..<20000), Mint]
var dp = lc[Mint.fact(n * 2) / (Mint(2)^n * Mint.fact(n)) | (n <- 0..<20000), Mint]

# depth first search {{{
proc dfs[T](g:Graph[T], u:int, p = -1):array[2, seq[Mint]] =
  result = [@[Mint(0), Mint(1)], @[Mint(0), Mint(0)]]
  for e in g[u]:
    if e.dst == p: continue
    var v = g.dfs(e.dst, u)
    let L = result[0].len + v[0].len - 1
    result2 := [Seq(L, Mint(0)), Seq(L, Mint(0))]
    for ei in 0..1:
      for i in 0..<result[ei].len:
        for ej in 0..1:
          for j in 0..<v[ej].len:
            let
              e = if ei == ej: 0 else: 1
              e2 = (e + 1) mod 2
              p = result[ei][i] * v[ej][j]
            result2[e][i + j] += p
            if j mod 2 == 0:
              let n = j div 2
              result2[e2][i] += p * dp[n]
    swap(result, result2)
#}}}

proc main() =
  g := initGraph[int](N)
  for i in 0..<N-1:
    g.addBiEdge(x[i], y[i])
  v := g.dfs(0)
  ans := Mint(0)
  for i in 0..1:
    let e = if i == 0: 1 else: -1
    for j in 0..<v[i].len:
      if j mod 2 == 0:
        let n = j div 2
        ans += v[i][j] * dp[n] * e
  print ans

main()

