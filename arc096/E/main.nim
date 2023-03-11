#. header {{{
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

var N:int
var M:int

const Mod = 123456791

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
    return T.Mod
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

proc fact(T:typedesc[IntC], k:int):T =
  var fact_a{.global.} = newSeq[T]()
  if k >= fact_a.len:
    if fact_a.len == 0: fact_a = @[T(1)]
    let sz_old = fact_a.len - 1
    let sz = max(sz_old * 2, k)
    fact_a.setlen(sz + 1)
    for i in sz_old + 1..sz: fact_a[i] = fact_a[i-1] * T(i)
  return fact_a[k]
proc rfact(T:typedesc[IntC], k:int):T =
  var rfact_a{.global.} = newSeq[T]()
  if k >= rfact_a.len:
    if rfact_a.len == 0: rfact_a = @[T(1)]
    let sz_old = rfact_a.len - 1
    let sz = max(sz_old * 2, k)
    rfact_a.setlen(sz + 1)
    rfact_a[sz] = T(1) / T.fact(sz)
    for i in countdown(sz - 1, sz_old + 1): rfact_a[i] = rfact_a[i + 1] * T(i + 1)
  return rfact_a[k]

proc inv(T:typedesc[IntC], k:int):T =
  return T.fact_a(k - 1) * T.rfact(k)

proc P(T:typedesc[IntC], n,r:int):T =
  if r < 0 or n < r: return T(0)
  return T.fact(n) * T.rfact(n - r)
proc C(T:typedesc[IntC], p,q:int):T =
  if q < 0 or p < q: return T(0)
  return T.fact(p) * T.rfact(q) * T.rfact(p - q)
proc H(T: typedesc[IntC], n,r:int):T =
  if n < 0 or r < 0: return T(0)
  return if r == 0: T(1) else: T.C(n + r - 1, r)
# }}}

# modPow(x, n, p) {{{
proc modPow[T](x,n,p:T):T =
  var (x,n) = (x,n)
  result = T(1)
  while n > 0:
    if (n and 1) > 0: result *= x; result = result mod p
    x *= x; x = x mod p
    n = (n shr 1)
# }}}

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
#}}}

type Mi = DMint

proc main() =
  Mi.setMod(M)
  dp := Seq(N + 1, Mi(0))
  dp[0] = Mi(1)
  ans := Mi(0)
  for k in 0..N:
    d := N - k
    e := modPow(2, d, M - 1)
    p := Mi(2)^e
    q := Mi(2)^d
    for t in 0..N:
#      x := dp[t] * DMint(2)^(e + d * t) * Dmint.C(N, k)
      var x = dp[t] * p * Mi.C(N, k)
      if k mod 2 == 0:
        ans += x
      else:
        ans -= x
      p *= q
    if k == N: break
    dp2 := dp
    for t in 0..<N:
      dp2[t+1] += dp[t]
    for t in 0..N:
      dp2[t] += dp[t] * t
    swap(dp, dp2)
  print ans
  return

main()
