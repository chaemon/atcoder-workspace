# header {{{
{.hints:off warnings:off optimization:speed.}
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
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

const MOD = 998244353
var N:int
var X:int

# input part {{{
proc main()
block:
  N = nextInt()
  X = nextInt()
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

proc getMod[Mod:static[int]](self: ModInt[Mod]):static int32 = self.Mod
proc getMod[Mod:static[int]](self: typedesc[ModInt[Mod]]):static int32 = self.Mod

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

# DynamicModInt {{{
type DMint = object
  v:int32

proc setModSub(self:typedesc[not ModInt], m:int = -1, update = false):int32 =
  {.noSideEffect.}:
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
proc initDMint(a:SomeInteger, Mod:int):DMint = result.v = fastMod(a.int, Mod.uint32).int32

proc getMod[T:not ModInt](self: T):int32 = T.type.setModSub()
proc getMod(self: typedesc[not ModInt]):int32 = self.setModSub()
proc setMod(self: typedesc[not ModInt], m:int) = discard self.setModSub(m, update = true)
#}}}

# Operations {{{
type ModIntC = concept x, type T
  x.v
#  x.v is int32
#  x.getMod() is int32
#  when T isnot ModInt: setMod(T, int)
type SomeIntC = concept x
  x is SomeInteger or x is ModIntC

proc Identity(self:ModIntC):auto = result = self;result.v = 1
proc init[Mod:static[int]](self:ModInt[Mod], a:SomeIntC):ModInt[Mod] =
  when a is SomeInteger: initModInt(a, Mod)
  else: a
proc init(self:ModIntC and not ModInt, a:SomeIntC):auto =
  when a is SomeInteger:
    var r = self.type.default
    r.v = fastMod(a.int, self.getMod().uint32).int32
    r
  else: a

macro declareDMintConverter(t:untyped) =
  parseStmt(fmt"""
converter to{t.repr}(a:SomeInteger):{t.repr} =
  let Mod = {t.repr}.getMod()
  if Mod > 0:
    result.v = fastMod(a.int, Mod.uint32).int32
  else:
    result.v = a.int32
  return result
""")

declareDMintConverter(DMint)

macro declareDMint(t:untyped) =
  parseStmt(fmt"""
type {t.repr} {{.borrow: `.`.}} = distinct DMint
declareDMintConverter({t.repr})
""")

proc `*=`(self:var ModIntC, a:SomeIntC) =
  when self is ModInt:
    self.v = (self.v.int * self.init(a).v.int mod self.getMod().int).int32
  else:
    self.v = fastMod(self.v.int * self.init(a).v.int, self.getMod().uint32).int32
proc `==`(a:ModIntC, b:SomeIntC):bool = a.v == a.init(b).v
proc `!=`(a:ModIntC, b:SomeIntC):bool = a.v != a.init(b).v
proc `-`(self:ModIntC):auto =
  if self.v == 0: return self
  else: return self.init(self.getMod() - self.v)
proc `$`(a:ModIntC):string = return $(a.v)

proc `+=`(self:var ModIntC; a:SomeIntC) =
  self.v += self.init(a).v
  if self.v >= self.getMod(): self.v -= self.getMod()
proc `-=`(self:var ModIntC, a:SomeIntC) =
  self.v -= self.init(a).v
  if self.v < 0: self.v += self.getMod()
proc `^=`(self:var ModIntC, n:SomeInteger) =
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
  return self.init(u)
proc `/=`(a:var ModIntC,b:SomeIntC) = a *= a.init(b).inverse()
proc `+`(a:ModIntC,b:SomeIntC):auto = result = a;result += b
proc `-`(a:ModIntC,b:SomeIntC):auto = result = a;result -= b
proc `*`(a:ModIntC,b:SomeIntC):auto = result = a;result *= b
proc `/`(a:ModIntC,b:SomeIntC):auto = result = a;result /= b
proc `^`(a:ModIntC,b:SomeInteger):auto = result = a;result ^= b
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

import options

proc calc(n, s:int):Mint =
  if n * 2 < s or s < n: return 0
  return Mint.C(n, s - n)

proc calc12(n, s:int):Mint =
  if s <= X - 1:
    return calc(n, s)
  elif s <= (X - 1) * 2:
    let k = s - (X - 1)
    if k mod 2 != 0: return 0
    return calc(n - k, s - k * 2)
  else:
    # all 2
    if n * 2 != s or X mod 2 == 0: return 0
    else: return 1

proc main() =
  var ans:Mint = 0
  for n in 0..N:
    for s in 0..n*2:
      let t = calc12(n, s)
      ans += t * Mint.C(N, n)
  print ans
  return

main()

