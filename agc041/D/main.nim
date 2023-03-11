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

var N:int
var M:int

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
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

#{{{ FastFourierTransform
# clongdouble {{{
proc `+`(a, b:clongdouble):clongdouble {.importcpp: "(#) + (@)", nodecl.}
proc `-`(a, b:clongdouble):clongdouble {.importcpp: "(#) - (@)", nodecl.}
proc `*`(a, b:clongdouble):clongdouble {.importcpp: "(#) * (@)", nodecl.}
proc `/`(a, b:clongdouble):clongdouble {.importcpp: "(#) / (@)", nodecl.}
proc `-`(a:clongdouble):clongdouble {.importcpp: "-(#)", nodecl.}
proc sqrt(a:clongdouble):clongdouble {.header: "<cmath>", importcpp: "sqrtl(#)", nodecl.}
proc exp(a:clongdouble):clongdouble {.header: "<cmath>", importcpp: "expl(#)", nodecl.}
proc sin(a:clongdouble):clongdouble {.header: "<cmath>", importcpp: "sinl(#)", nodecl.}
proc acos(a:clongdouble):clongdouble {.header: "<cmath>", importcpp: "acosl(#)", nodecl.}
proc cos(a:clongdouble):clongdouble {.header: "<cmath>", importcpp: "cosl(#)", nodecl.}
proc llround(a:clongdouble):int {.header: "<cmath>", importcpp: "std::llround(#)", nodecl.}
# }}}

import math, sequtils, bitops

type Real = float
#type Real = clongdouble

type C = tuple[x, y:Real]

proc initC[S,T](x:S, y:T):C = (Real(x), Real(y))

proc `+`(a,b:C):C = initC(a.x + b.x, a.y + b.y)
proc `-`(a,b:C):C = initC(a.x - b.x, a.y - b.y)
proc `*`(a,b:C):C = initC(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
proc conj(a:C):C = initC(a.x, -a.y)

type SeqC = object
  real, imag: seq[Real]

proc initSeqC(n:int):SeqC = SeqC(real: newSeqWith(n, Real(0)), imag: newSeqWith(n, Real(0)))

proc setLen(self: var SeqC, n:int) =
  self.real.setLen(n)
  self.imag.setLen(n)
proc swap(self: var SeqC, i, j:int) =
  swap(self.real[i], self.real[j])
  swap(self.imag[i], self.imag[j])

type FastFourierTransform = object of RootObj
  base:int
  rts: SeqC
  rev:seq[int]

proc getC(self: SeqC, i:int):C = (self.real[i], self.imag[i])
proc `[]`(self: SeqC, i:int):C = self.getC(i)
proc `[]=`(self: var SeqC, i:int, x:C) =
  self.real[i] = x.x
  self.imag[i] = x.y

proc initFastFourierTransform():FastFourierTransform = 
  return FastFourierTransform(base:1, rts: SeqC(real: @[Real(0), Real(1)], imag: @[Real(0), Real(0)]), rev: @[0, 1])
#proc init(self:typedesc[FastFourierTransform]):auto = initFastFourierTransform()

proc ensureBase(self:var FastFourierTransform; nbase:int) =
  if nbase <= self.base: return
  let L = 1 shl nbase
  self.rev.setlen(1 shl nbase)
  self.rts.setlen(1 shl nbase)
  for i in 0..<(1 shl nbase): self.rev[i] = (self.rev[i shr 1] shr 1) + ((i and 1) shl (nbase - 1))
  while self.base < nbase:
    let angle = acos(Real(-1)) * Real(2) / Real(1 shl (self.base + 1))
    for i in (1 shl (self.base - 1))..<(1 shl self.base):
      self.rts[i shl 1] = self.rts[i]
      let angle_i = angle * Real(2 * i + 1 - (1 shl self.base))
      self.rts[(i shl 1) + 1] = initC(cos(angle_i), sin(angle_i))
    self.base.inc

proc fft(self:var FastFourierTransform; a:var SeqC, n:int) =
  assert((n and (n - 1)) == 0)
  let zeros = countTrailingZeroBits(n)
  self.ensureBase(zeros)
  let shift = self.base - zeros
  for i in 0..<n:
    if i < (self.rev[i] shr shift):
      a.swap(i, self.rev[i] shr shift)
  var k = 1
  while k < n:
    var i = 0
    while i < n:
      for j in 0..<k:
        let z = a[i + j + k] * self.rts[j + k]
        a[i + j + k] = a[i + j] - z
        a[i + j] = a[i + j] + z
      i += 2 * k
    k = k shl 1

proc ifft(self: var FastFourierTransform; a: var SeqC, n:int) =
  for i in 0..<n: a[i] = a[i].conj()
  let rN = clongdouble(1) / clongdouble(n)
  self.fft(a, n)
  for i in 0..<n:
    let t = a[i]
    a[i] = (t.x * rN, t.y * rN)

proc multiply(self:var FastFourierTransform; a,b:seq[int]):seq[int] =
  let need = a.len + b.len - 1
  var nbase = 1
  while (1 shl nbase) < need: nbase.inc
  self.ensureBase(nbase)
  let sz = 1 shl nbase
  var fa = initSeqC(sz)
  for i in 0..<sz:
    let x = if i < a.len: a[i] else: 0
    let y = if i < b.len: b[i] else: 0
    fa[i] = initC(x, y)
  self.fft(fa, sz)
  let
    r = initC(0, - Real(1) / (Real((sz shr 1) * 4)))
    s = initC(0, 1)
    t = initC(Real(1)/Real(2), 0)
  for i in 0..(sz shr 1):
    let j = (sz - i) and (sz - 1)
    let z = (fa[j] * fa[j] - (fa[i] * fa[i]).conj()) * r
    fa[j] = (fa[i] * fa[i] - (fa[j] * fa[j]).conj()) * r
    fa[i] = z
  for i in 0..<(sz shr 1):
    let A0 = (fa[i] + fa[i + (sz shr 1)]) * t
    let A1 = (fa[i] - fa[i + (sz shr 1)]) * t * self.rts[(sz shr 1) + i]
    fa[i] = A0 + A1 * s
  self.fft(fa, sz shr 1)
  var ret = newSeq[int](need)
  for i in 0..<need: ret[i] = llround(if (i and 1)>0: fa[i shr 1].y else: fa[i shr 1].x)
  return ret

var fft_t = initFastFourierTransform()
#}}}

const ArbitraryMod = true
#{{{ ArbitraryModFFT
type ArbitraryModFFT[ModInt] = object

proc init[ModInt](t:typedesc[ArbitraryModFFT[ModInt]]):auto =
  ArbitraryModFFT[ModInt]()

proc ceil_log2(n:int):int =
  result = 0
  while (1 shl result) < n: result.inc

proc fft[ModInt](self: var ArbitraryModFFT[ModInt], a:seq[ModInt]):SeqC =
  doAssert((a.len and (a.len - 1)) == 0)
  let l = ceil_log2(a.len)
  fft_t.ensureBase(l)
  result = initSeqC(a.len)
  for i in 0..<a.len: result[i] = initC(a[i].v and ((1 shl 15) - 1), a[i].v shr 15)
  fft_t.fft(result, a.len)

proc dot[ModInt](self: ArbitraryModFFT[ModInt], fa: SeqC, fb:SeqC):(SeqC, SeqC) =
  let sz = fa.real.len
  var (fa, fb) = (fa, fb)
  let ratio = Real(1) / (Real(sz) * Real(4))
  let
    r2 = initC(0, -1)
    r3 = initC(ratio, 0)
    r4 = initC(0, -ratio)
    r5 = initC(0, 1)
  for i in 0..(sz shr 1):
    let
      j = (sz - i) and (sz - 1)
      a1 = (fa[i] + fa[j].conj())
      a2 = (fa[i] - fa[j].conj()) * r2
      b1 = (fb[i] + fb[j].conj()) * r3
      b2 = (fb[i] - fb[j].conj()) * r4
    if i != j:
      let
        c1 = (fa[j] + fa[i].conj())
        c2 = (fa[j] - fa[i].conj()) * r2
        d1 = (fb[j] + fb[i].conj()) * r3
        d2 = (fb[j] - fb[i].conj()) * r4
      fa[i] = c1 * d1 + c2 * d2 * r5
      fb[i] = c1 * d2 + c2 * d1
    fa[j] = a1 * b1 + a2 * b2 * r5
    fb[j] = a1 * b2 + a2 * b1
  return (fa, fb)

proc ifft[ModInt](self: var ArbitraryModFFT[ModInt], p:(SeqC, SeqC), need = -1):seq[ModInt] =
  var
    (fa, fb) = p
  let
    sz = fa.real.len
  fft_t.fft(fa, sz)
  fft_t.fft(fb, sz)
  let need = if need == -1: fa.real.len else: need
  result = newSeq[ModInt](need)
  for i in 0..<need:
    var
      aa = llround(fa[i].x)
      bb = llround(fb[i].x)
      cc = llround(fa[i].y)
    aa = ModInt(aa).v; bb = ModInt(bb).v; cc = ModInt(cc).v
    result[i] = ModInt(aa + (bb shl 15) + (cc shl 30))

proc multiply[ModInt](self:var ArbitraryModFFT[ModInt], a,b:seq[ModInt], need = -1):seq[ModInt] =
  var need = need
  if need == -1: need = a.len + b.len - 1
  var nbase = ceil_log2(need)
  fft_t.ensureBase(nbase)
  let sz = 1 shl nbase
  var (a, b) = (a, b)
  a.setlen(sz)
  b.setlen(sz)
  var
    fa1 = self.fft(a)
    fb1 = if a == b: fa1 else: self.fft(b)
  (fa1, fb1) = self.dot(fa1, fb1)
  return self.ifft((fa1, fb1), need)
#}}}

const FastMod = true
const UseFFT = true

# FormalPowerSeries {{{
import sugar, sequtils, strformat, options

type FieldElem = concept x, type T
  x + x
  x - x
  x * x
  x / x

type FormalPowerSeries[T:FieldElem] = seq[T]
type SparseFormalPowerSeries[T:FieldElem] = seq[(int, T)]

when not declared(FastMult):
  const FastMult = true
when not declared(UseFFT):
  const UseFFT = true
when not declared(ArbitraryMod):
  const ArbitraryMod = false
when UseFFT or FastMult:
  when ArbitraryMod:
    when declared(ArbitraryModNTT):
      type BaseFFT[T] = ArbitraryModNTT[T]
    elif declared(ArbitraryModFFT):
      type BaseFFT[T] = ArbitraryModFFT[T]
    else:
      assert(false)
  else:
    when declared(NumberTheoreticTransform):
      type BaseFFT[T] = NumberTheoreticTransform[T]
    else:
      assert(false)
  proc getFFT[T](self:FormalPowerSeries[T]):ptr BaseFFT[T] =
    var fft {.global.} = BaseFFT[T].init()
    return fft.addr

template initFormalPowerSeries[T:FieldElem](data: typed):FormalPowerSeries[T] =
  when data is int: FormalPowerSeries[T](newSeq[T](data))
  else: data.mapIt(T(it))

proc `$`[T](self:FormalPowerSeries[T]):string = return self.mapIt($it).join(" ")

macro revise(a, b) =
  parseStmt(fmt"""let {a.repr} = if {a.repr} == -1: {b.repr} else: {a.repr}""")
# sqrt {{{
type
  SQRT[T] = proc(t:T):Option[T]

proc sqrtSub[T](self:FormalPowerSeries[T], update: bool, f:SQRT[T]):(bool, SQRT[T]){.discardable.} =
  var is_set{.global.} = false
  var sqr{.global.}:SQRT[T] = nil
  if update:
    is_set = true
    sqr = f
  return (is_set, sqr)
proc isSetSqrt[T](self:FormalPowerSeries[T]):bool = return self.sqrtSub(false, nil)[0]
proc setSqrt[T](self:FormalPowerSeries[T], f: SQRT[T]):SQRT[T]{.discardable.} = return self.sqrtSub(true, f)[1]
proc getSqrt[T](self:FormalPowerSeries[T]):SQRT[T]{.discardable.} = return self.sqrtSub(false, nil)[1]
#}}}

proc shrink[T](self: var FormalPowerSeries[T]) =
  while self.len > 0 and self[^1] == 0: discard self.pop()

# operators +=, -=, *=, mod=, -, /= {{{
proc `+=`(self: var FormalPowerSeries, r:FormalPowerSeries) =
  if r.len > self.len: self.setlen(r.len)
  for i in 0..<r.len: self[i] += r[i]
proc `+=`[T](self: var FormalPowerSeries[T], r:T) =
  if self.len == 0: self.setlen(1)
  self[0] += r

proc `-=`[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) =
  if r.len > self.len: self.setlen(r.len)
  for i in 0..<r.len: self[i] -= r[i]
  self.shrink()
proc `-=`[T](self: var FormalPowerSeries[T], r:T) =
  if self.len == 0: self.setlen(1)
  self[0] -= r
  self.shrink()

proc `*=`[T](self: var FormalPowerSeries[T], v:T) = self.applyIt(it * v)

proc multRaw[T](a:FormalPowerSeries[T], b:SparseFormalPowerSeries[T], deg = -1):FormalPowerSeries[T] =
  var deg = deg
  if deg == -1:
    var bdeg = 0
    for p in b: bdeg = max(bdeg, p[0])
    deg = a.len + bdeg
  result = initFormalPowerSeries[T](deg)
  for i in 0..<a.len:
    for (j, c) in b:
      let k = i + j
      if k < deg: result[k] += a[i] * c
proc multRaw[T](a, b:SparseFormalPowerSeries[T], deg = -1):SparseFormalPowerSeries[T] =
  var r = initTable[int,T]()
  for (i, c0) in a:
    for (j, c1) in b:
      let k = i + j
      if deg != -1 and k >= deg: continue
      if k notin r: r[k] = T(0)
      r[k] += c0 * c1
  return toSeq(r.pairs)

proc `*=`[T](self: var FormalPowerSeries[T],  r: FormalPowerSeries[T]) =
  if self.len == 0 or r.len == 0:
    self.setlen(0)
  else:
    when FastMult:
      var fft = self.getFFT()
      self = fft[].multiply(self, r)
    else:
      assert(false)

proc `mod=`[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) = self -= self div r * r

proc `-`[T](self: FormalPowerSeries[T]):FormalPowerSeries[T] =
  var ret = self
  ret.applyIt(-it)
  return ret
proc `/=`[T](self: var FormalPowerSeries[T], v:T) = self.applyIt(it / v)
#}}}

# operators +, -, *, div, mod {{{
macro declareOp(op) =
  fmt"""proc `{op}`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T] or T):FormalPowerSeries[T] = result = self;result {op}= r
proc `{op}`[T](self: not FormalPowerSeries, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = initFormalPowerSeries[T](@[self]);result {op}= r""".parseStmt

declareOp(`+`)
declareOp(`-`)
declareOp(`*`)
declareOp(`/`)

proc `div`[T](self, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`div=` (r)
proc `mod`[T](self, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`mod=` (r)
# }}}

proc rev[T](self: FormalPowerSeries[T], deg = -1):auto =
  result = self
  if deg != -1: result.setlen(deg)
  result.reverse

proc pre[T](self: FormalPowerSeries[T], sz:int):auto =
  result = self
  result.setlen(min(self.len, sz))

proc `div=`[T](self: var FormalPowerSeries[T], r: FormalPowerSeries[T]) =
  if self.len < r.len:
    self.setlen(0)
  else:
    let n = self.len - r.len + 1
    self = (self.rev().pre(n) * r.rev().inv(n)).pre(n).rev(n)

proc dot[T](self:FormalPowerSeries[T], r: FormalPowerSeries[T]):auto =
  result = initFormalPowerSeries[T](min(self.len, r.len))
  for i in 0..<result.len: result[i] = self[i] * r[i]

proc `shr`[T](self: FormalPowerSeries[T], sz:int):auto =
  if self.len <= sz: return initFormalPowerSeries[T](0)
  result = self
  if sz >= 1: result.delete(0, sz - 1)
proc `shl`[T](self: FormalPowerSeries[T], sz:int):auto =
  result = initFormalPowerSeries[T](sz)
  result = result & self

proc diff[T](self: FormalPowerSeries[T]):auto =
  let n = self.len
  result = initFormalPowerSeries[T](max(0, n - 1))
  for i in 1..<n:
    result[i - 1] = self[i] * T(i)

proc integral[T](self: FormalPowerSeries[T]):auto =
  let n = self.len
  result = initFormalPowerSeries[T](n + 1)
  result[0] = T(0)
  for i in 0..<n: result[i + 1] = self[i] / T(i + 1)

# F(0) must not be 0
proc inv[T](self: FormalPowerSeries[T], deg = -1):auto =
  doAssert(self[0] != 0)
  deg.revise(self.len)
  when UseFFT:
    proc invFast[T](self: FormalPowerSeries[T]):auto =
      doAssert(self[0] != 0)
      let n = self.len
      var res = initFormalPowerSeries[T](1)
      res[0] = T(1) / self[0]
      var fft = self.getFFT()
      var d = 1
      while d < n:
        var f, g = initFormalPowerSeries[T](2 * d)
        for j in 0..<min(n, 2 * d): f[j] = self[j]
        for j in 0..<d: g[j] = res[j]
        let g1 = fft[].fft(g)
        f = fft[].ifft(fft[].dot(fft[].fft(f), g1))
        for j in 0..<d:
          f[j] = T(0)
          f[j + d] = -f[j + d]
        f = fft[].ifft(fft[].dot(fft[].fft(f), g1))
        f[0..<d] = res[0..<d]
        res = f
        d = d shl 1
      return res.pre(n)
    var ret = self
    ret.setlen(deg)
    return ret.invFast()
  else:
    var ret = initFormalPowerSeries[T](1)
    ret[0] = T(1) / self[0]
    var i = 1
    while i < deg:
      ret = (ret + ret - ret * ret * self.pre(i shl 1)).pre(i shl 1)
      i = i shl 1
    return ret.pre(deg)

# F(0) must be 1
proc log[T](self:FormalPowerSeries[T], deg = -1):auto =
  doAssert self[0] == T(1)
  deg.revise(self.len)
  return (self.diff() * self.inv(deg)).pre(deg - 1).integral()

proc sqrt[T](self: FormalPowerSeries[T], deg = -1):auto =
  let n = self.len
  deg.revise(n)
  if self[0] == 0:
    for i in 1..<n:
      if self[i] != 0:
        if (i and 1) > 0: return FormalPowerSeries[T].none
        if deg - i div 2 <= 0: break
        var opt = (self shr i).sqrt(deg - i div 2)
        if not opt.isSome: return FormalPowerSeries[T].none
        var ret = opt.get shl (i div 2)
        if ret.len < deg: ret.setlen(deg)
        return ret.some
    return initFormalPowerSeries[T](deg).some

  var ret:FormalPowerSeries[T]
  if self.isSetSqrt:
    let opt = self.getSqrt()(self[0])
    if not opt.isSome: return FormalPowerSeries[T].none
    ret = initFormalPowerSeries[T](@[T(opt.get)])
  else:
    doAssert(self[0] == 1)
    ret = initFormalPowerSeries[T](@[T(1)])

  let inv2 = T(1) / T(2);
  var i = 1
  while i < deg:
    ret = (ret + self.pre(i shl 1) * ret.inv(i shl 1)) * inv2
    i = i shl 1
  return ret.pre(deg).some

import typetraits

# F(0) must be 0
proc exp[T](self: FormalPowerSeries[T], deg = -1):auto =
  doAssert self[0] == 0
  deg.revise(self.len)
  when UseFFT:
    proc onlineConvolutionExp[T](self, conv_coeff:FormalPowerSeries[T]):auto =
      var fft = self.getFFT()
      let n = conv_coeff.len
      doAssert((n and (n - 1)) == 0)
      type FFTType = fft[].fft(initFormalPowerSeries[T](0)).type
      var
        conv_ntt_coeff = newSeq[FFTType]()
        i = n
      while (i shr 1) > 0:
        var g = conv_coeff.pre(i)
        conv_ntt_coeff.add(fft[].fft(g))
        i = i shr 1
      var conv_arg, conv_ret = initFormalPowerSeries[T](n)
      proc rec(l,r,d:int) =
        if r - l <= 16:
          for i in l..<r:
            var sum = T(0)
            for j in l..<i: sum += conv_arg[j] * conv_coeff[i - j]
            conv_ret[i] += sum
            conv_arg[i] = if i == 0: T(1) else: conv_ret[i] / i
        else:
          var m = (l + r) div 2
          rec(l, m, d + 1)
          var pre = initFormalPowerSeries[T](r - l)
          pre[0..<m-l] = conv_arg[l..<m]
          pre = fft[].ifft(fft[].dot(fft[].fft(pre), conv_ntt_coeff[d]))
          for i in 0..<r - m: conv_ret[m + i] += pre[m + i - l]
          rec(m, r, d + 1)
      rec(0, n, 0)
      return conv_arg
    proc expRec[T](self: FormalPowerSeries[T]):auto =
      doAssert self[0] == 0
      let n = self.len
      var m = 1
      while m < n: m *= 2
      var conv_coeff = initFormalPowerSeries[T](m)
      for i in 1..<n: conv_coeff[i] = self[i] * i
      return self.onlineConvolutionExp(conv_coeff).pre(n)
    var ret = self
    ret.setlen(deg)
    return ret.expRec()
  else:
    var
      ret = initFormalPowerSeries[T](@[T(1)])
      i = 1
    while i < deg:
      ret = (ret * (self.pre(i shl 1) + T(1) - ret.log(i shl 1))).pre(i shl 1);
      i = i shl 1
    return ret.pre(deg)

proc exponent[T](a:FormalPowerSeries[T]):FormalPowerSeries[T] =
  assert(a.len == 0 or a[0] == 0);
  var
    a = a
    b = initFormalPowerSeries[T]([1])
  while b.len < a.len:
    var x = a[0..<min(a.len, 2 * b.len)]
    x[0] += 1
    b.setLen(2 * b.len)
    x -= log(b)
    let l = b.len div 2
    x *= b[0..<l]
    for i in l..<min(x.len, b.len):
      b[i] = x[i]
  return b[0..<a.len]

proc pow[T](self: FormalPowerSeries[T], k:int, deg = -1):auto =
  var self = self
  let n = self.len
  deg.revise(n)
  self.setLen(deg)
  for i in 0..<n:
    if self[i] != T(0):
      let rev = T(1) / self[i]
      result = (((self * rev) shr i).log(deg) * T(k)).exp() * (self[i]^k)
      if i * k > deg: return initFormalPowerSeries[T](deg)
      result = (result shl (i * k)).pre(deg)
      if result.len < deg: result.setlen(deg)
      return
  return self

proc eval[T](self: FormalPowerSeries[T], x:T):T =
  var
    r = T(0)
    w = T(1)
  for v in self:
    r += w * v
    w *= x
  return r

proc powMod[T](self: FormalPowerSeries[T], n:int, M:FormalPowerSeries[T]):auto =
  let modinv = M.rev().inv()
  proc getDiv(base:FormalPowerSeries[T]):FormalPowerSeries[T] =
    var base = base
    if base.len < M.len:
      base.setlen(0)
      return base
    let n = base.len - M.len + 1
    return (base.rev().pre(n) * modinv.pre(n)).pre(n).rev(n)
  var
    n = n
    x = self
    ret = initFormalPowerSeries[T](@[T(1)])
  while n > 0:
    if (n and 1) > 0:
      ret *= x
      ret -= getDiv(ret) * M
    x *= x
    x -= getDiv(x) * M
    n = n shr 1
  return ret

# }}}

proc main() =
  DMint.setMod M
  f := initFormalPowerSeries[DMint](N)
  f[0] = 1
  if N mod 2 == 0:
    let n = N div 2
    for i in 1..n:
      base := @[(0, DMint 1), (i, DMint -1)]
      var g:SparseFormalPowerSeries[DMint]
      # multiply (1 - q)
      if i == 1:
        # (1 - 3q + 3q^2 - q^3)
        g = base.multRaw(base).multRaw(base)
      else:
        # (1 - 2q + q^2)
        g = base.multRaw(base)
      f = f.multRaw(g, N)
  else:
    let n = (N + 1) div 2
    for i in 1..n:
      var g:SparseFormalPowerSeries[DMint]
      base := @[(0, DMint 1), (i, DMint -1)]
      if i == 1:
        # (1 - 3q + 3q^2 - q^3)
        g = base.multRaw(base).multRaw(base)
      elif i < n:
        # (1 - 2q + q^2)
        g = base.multRaw(base)
      else:
        # (1 - q)
        g = base
      f = f.multRaw(g, N)
  f = f.inv
#  f = f.exp(N)
  echo f[N - 1]
  return

main()

