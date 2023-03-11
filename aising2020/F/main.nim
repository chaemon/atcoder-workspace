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

const MOD = 1000000007

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
  x.v is int32
  x.getMod() is int32
  when T isnot ModInt: setMod(T, int)
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

proc Comb(T:typedesc, n, r:int):T =
  if n < 0:
    let n = -n
    result = T.Comb(n + r - 1, r)
    if r mod 2 == 1: result *= -1
  else:
    var r = r
    if r < 0 or n < r: return T(0)
    if n - r < r: r = n - r
    var num, den = T(1)
    for i in 0..<r:
      num *= n - i
      den *= i + 1
    return num / den

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: doAssert(false)
proc writeBits[B:SomeInteger](b:B) =
  var n = sizeof(B) * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B =
  if n == 64:
    return not uint64(0)
  else:
    return (B(1) shl B(n)) - B(1)
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if not s.testBit(i):
        found = true
        s.setBit(i)
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

#{{{ FastFourierTransformLongDouble

proc llround(n: float): int{.importc: "llround", nodecl.}

# LongDouble {{{
type LongDouble {.importcpp: "long double", nodecl .} = object
  discard

proc initLongDouble(a:SomeNumber):LongDouble {.importcpp: "(long double)(#)", nodecl.}
converter toLongDouble(a:SomeNumber):LongDouble = initLongDouble(a)

proc `+`(a, b:LongDouble):LongDouble {.importcpp: "(#) + (@)", nodecl.}
proc `-`(a, b:LongDouble):LongDouble {.importcpp: "(#) - (@)", nodecl.}
proc `*`(a, b:LongDouble):LongDouble {.importcpp: "(#) * (@)", nodecl.}
proc `/`(a, b:LongDouble):LongDouble {.importcpp: "(#) / (@)", nodecl.}
proc `-`(a:LongDouble):LongDouble {.importcpp: "-(#)", nodecl.}
proc `sqrt`(a:LongDouble):LongDouble {.header: "<cmath>", importcpp: "sqrtl(#)", nodecl.}
proc `exp`(a:LongDouble):LongDouble {.header: "<cmath>", importcpp: "expl(#)", nodecl.}
proc `sin`(a:LongDouble):LongDouble {.header: "<cmath>", importcpp: "sinl(#)", nodecl.}
proc `cos`(a:LongDouble):LongDouble {.header: "<cmath>", importcpp: "cosl(#)", nodecl.}
proc `llround`(a:LongDouble):int {.header: "<cmath>", importcpp: "llround(#)", nodecl.}
# }}}

import math, sequtils, bitops

type Real = LongDouble

type C = tuple[x, y:Real]

proc initC[S,T](x:S, y:T):C = (x.Real, y.Real)

proc `+`(a,b:C):C = initC(a.x + b.x, a.y + b.y)
proc `-`(a,b:C):C = initC(a.x - b.x, a.y - b.y)
proc `*`(a,b:C):C = initC(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
proc conj(a:C):C = initC(a.x, -a.y)

type SeqC = object
  real, imag: seq[LongDouble]
proc initSeqC(n:int):SeqC = SeqC(real: newSeqWith(n, LongDouble(0)), imag: newSeqWith(n, LongDouble(0)))

proc setLen(self: var SeqC, n:int) =
  self.real.setLen(n)
  self.imag.setLen(n)
proc swap(self: var SeqC, i, j:int) =
  swap(self.real[i], self.real[j])
  swap(self.imag[i], self.imag[j])

type FastFourierTransformLongDouble = object
  base:int
  rts: SeqC
  rev:seq[int]

proc getC(self: SeqC, i:int):C = (self.real[i], self.imag[i])
proc `[]`(self: SeqC, i:int):C = self.getC(i)
proc `[]=`(self: var SeqC, i:int, x:C) =
  self.real[i] = x.x
  self.imag[i] = x.y

proc initFastFourierTransformLongDouble():FastFourierTransformLongDouble = 
  return FastFourierTransformLongDouble(base:1, rts: SeqC(real: @[LongDouble(0), LongDouble(1)], imag: @[LongDouble(0), LongDouble(0)]), rev: @[0, 1])

proc ensureBase(self:var FastFourierTransformLongDouble; nbase:int) =
  if nbase <= self.base: return
  let L = 1 shl nbase
  self.rev.setlen(1 shl nbase)
  self.rts.setlen(1 shl nbase)
  for i in 0..<(1 shl nbase): self.rev[i] = (self.rev[i shr 1] shr 1) + ((i and 1) shl (nbase - 1))
  while self.base < nbase:
    let angle = initLongDouble(PI) * initLongDouble(2) / initLongDouble(1 shl (self.base + 1))
    for i in (1 shl (self.base - 1))..<(1 shl self.base):
      self.rts[i shl 1] = self.rts[i]
      let angle_i = angle * initLongDouble(2 * i + 1 - (1 shl self.base))
      self.rts[(i shl 1) + 1] = initC(cos(angle_i), sin(angle_i))
    self.base.inc

proc fft(self:var FastFourierTransformLongDouble; a:var SeqC, n:int) =
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

proc multiply(self:var FastFourierTransformLongDouble; a,b:seq[int]):seq[int] =
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
#    r = initC(0, -0.25 / float(sz shr 1))
    r = initC(0, -Real(1) / (Real(sz shr 1) * Real(4)))
    s = initC(0, 1)
#    t = initC(0.5, 0)
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
#}}}

#{{{ ArbitraryModConvolution
type ArbitraryModConvolution[ModInt, FFT] = object
  discard

proc initArbitraryModConvolution[ModInt, FFT]():ArbitraryModConvolution[ModInt, FFT] =
  ArbitraryModConvolution[ModInt, FFT]()

#proc llround(n: float): int{.importc: "llround", nodecl.}

proc multiply[ModInt, FFT](self:ArbitraryModConvolution[ModInt, FFT], a,b:seq[ModInt], need = -1):seq[ModInt] =
  var need = need
  if need == -1: need = a.len + b.len - 1
  var nbase = 0
  while (1 shl nbase) < need: nbase.inc
  var fft = FFT()
  fft.ensureBase(nbase)
  let sz = 1 shl nbase
  var fa = initSeqC(sz)
  for i in 0..<a.len: fa[i] = initC(a[i].v and ((1 shl 15) - 1), a[i].v shr 15)
  fft.fft(fa, sz)
  var fb = initSeqC(sz)
  if a == b:
    fb = fa
  else:
    for i in 0..<b.len:
      fb[i] = initC(b[i].v and ((1 shl 15) - 1), b[i].v shr 15)
    fft.fft(fb, sz)
  let ratio = 1.Real / (sz.Real * 4.Real)
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
  fft.fft(fa, sz)
  fft.fft(fb, sz)
  result = newSeq[ModInt](need)
  for i in 0..<need:
    var
      aa = llround(fa[i].x)
      bb = llround(fb[i].x)
      cc = llround(fa[i].y)
    aa = ModInt(aa).v; bb = ModInt(bb).v; cc = ModInt(cc).v
    result[i] = ModInt(aa + (bb shl 15) + (cc shl 30))
#}}}

# FormalPowerSeries {{{
type FieldElem = concept x, type T
  x + x
  x - x
  x * x
  x / x

import sugar, sequtils

type FormalPowerSeries[T:FieldElem] = seq[T]

proc initFormalPowerSeries[T:FieldElem](n:int):auto = FormalPowerSeries[T](newSeq[T](n))

template initFormalPowerSeries[T, S](data: openArray[S]):auto =
  when S is T: data
  else: data.mapIt(T(it))
proc `$`[T](self:FormalPowerSeries[T]):string = return self.mapIt($it).join(" ")

#{{{ set mult, fft, sqrt
type
  MULT[T] = proc(a,b:FormalPowerSeries[T]):FormalPowerSeries[T]
  FFT[T] = proc(a:var FormalPowerSeries[T]):void
  SQRT[T] = proc(t:T):T

proc multSub[T](self:FormalPowerSeries[T], update: bool, f:MULT[T]):MULT[T]{.discardable.} =
  var is_set{.global.} = false
  var mult{.global.}:MULT[T] = nil
  if update:
    is_set = true
    mult = f
  return mult
template setMult[T](self:FormalPowerSeries[T], u):MULT[T] =
  self.multSub(true, proc(a,b:FormalPowerSeries[T]):FormalPowerSeries[T] = initFormalPowerSeries[T](u.multiply(a, b)))
proc getMult[T](self:FormalPowerSeries[T]):MULT[T]{.discardable.} = return self.multSub(false, nil)
proc FFTSub[T](self:FormalPowerSeries[T], update: bool, f, g:FFT[T]):(bool, FFT[T], FFT[T]) {.discardable.} =
  var is_set{.global.} = false
  var fft{.global.}:FFT[T] = nil
  var ifft{.global.}:FFT[T] = nil
  if update:
    is_set = true
    fft = f
    ifft = g
  return (is_set, fft, ifft)

template setFFT[T](self:FormalPowerSeries[T], u) =
  self.FFTSub(true, proc(a:var FormalPowerSeries[T]) = u.fft(a), proc(a:var FormalPowerSeries[T]) = u.ifft(a))
proc isSetFFT[T](self:FormalPowerSeries[T]):bool = return self.FFTSub(false, nil, nil)[0]
proc getFFT[T](self:FormalPowerSeries[T]):auto {.discardable.} = return self.FFTSub(false, nil, nil)

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
  while self.len > 0 and self[^1] == 0:
    discard self.pop()

#{{{ operators +=, -=, *=, mod=, -, /=
proc `+=`[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) =
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

proc `*=`[T](self: var FormalPowerSeries[T], v:T) =
  for t in self.mitems: t *= v

proc `*=`[T](self: var FormalPowerSeries[T],  r: FormalPowerSeries[T]) =
  if self.len == 0 or r.len == 0:
    self.setlen(0)
  else:
    self = (self.getMult)(self, r)

proc `mod=`[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) = self -= self div r * r

proc `-`[T](self: FormalPowerSeries[T]):FormalPowerSeries[T] =
  var ret = self
  for i in 0..<self.len: ret[i] = -self[i]
  return ret
proc `/=`[T](self: var FormalPowerSeries[T], v:T) =
  for t in self.mitems: t /= v
#}}}

proc rev[T](self: FormalPowerSeries[T], deg = -1):auto =
  var ret = self
  if deg != -1: ret.setlen(deg)
  ret.reverse
  return ret

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
  var ret = initFormalPowerSeries[T](min(self.len, r.len))
  for i in 0..<ret.len: ret[i] = self[i] * r[i]
  return ret

proc `shr`[T](self: FormalPowerSeries[T], sz:int):auto =
  if self.len <= sz: return initFormalPowerSeries[T](0)
  var ret = self
  if sz >= 1:
    ret.delete(0, sz - 1)
  return ret

proc `shl`[T](self: FormalPowerSeries[T], sz:int):auto =
  var ret = initFormalPowerSeries[T](sz)
  ret = ret & self
  return ret

proc diff[T](self: FormalPowerSeries[T]):auto =
  let n = self.len
  var ret = initFormalPowerSeries[T](max(0, n - 1))
  for i in 1..<n:
    ret[i - 1] = self[i] * T(i)
  return ret

proc integral[T](self: FormalPowerSeries[T]):auto =
  let n = self.len
  var ret = initFormalPowerSeries[T](n + 1)
  ret[0] = T(0)
  for i in 0..<n: ret[i + 1] = self[i] / T(i + 1)
  return ret

proc invFast[T](self: FormalPowerSeries[T]):auto =
  doAssert(self[0] != 0)
  let n = self.len

  var res = initFormalPowerSeries[T](1)
  res[0] = T(1) / self[0]
  let (is_set, fft, ifft) = self.getFFT()
  doAssert(is_set)
  var d = 1
  while d < n:
    var f, g = initFormalPowerSeries[T](2 * d)
    for j in 0..<min(n, 2 * d): f[j] = self[j]
    for j in 0..<d: g[j] = res[j]
    fft(f)
    fft(g)
    for j in 0..<2*d: f[j] *= g[j]
    ifft(f)
    for j in 0..<d:
      f[j] = T(0)
      f[j + d] = -f[j + d]
    fft(f)
    for j in 0..<2*d: f[j] *= g[j]
    ifft(f)
    for j in 0..<d: f[j] = res[j]
    res = f
    d = d shl 1
  return res.pre(n)

# F(0) must not be 0
proc inv[T](self: FormalPowerSeries[T], deg = -1):auto =
  doAssert(self[0] != 0)
  let n = self.len
  var deg = deg
  if deg == -1: deg = n
  if self.is_setFFT():
    var ret = self
    ret.setlen(deg)
    return ret.invFast()
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
  let n = self.len
  var deg = deg
  if deg == -1: deg = n
  return (self.diff() * self.inv(deg)).pre(deg - 1).integral()

proc sqrt[T](self: FormalPowerSeries[T], deg = -1):auto =
  let n = self.len
  var deg = deg
  if deg == -1: deg = n
  if self[0] == 0:
    for i in 1..<n:
      if self[i] != 0:
        if (i and 1) > 0: return initFormalPowerSeries[T](0)
        if deg - i div 2 <= 0: break
        var ret = (self shr i).sqrt(deg - i div 2)
        if ret.len == 0: return initFormalPowerSeries[T](0)
        ret = ret shl (i div 2)
        if ret.len < deg: ret.setlen(deg)
        return ret
    return initFormalPowerSeries[T](deg)

  var ret:FormalPowerSeries[T]
  if self.isSetSqrt:
    let sqr = self.getSqrt()(self[0])
    if sqr * sqr != self[0]: return initFormalPowerSeries[T](0)
    ret = initFormalPowerSeries[T](@[T(sqr)])
  else:
    doAssert(self[0] == 1)
    ret = initFormalPowerSeries[T](@[T(1)])

  let inv2 = T(1) / T(2);
  var i = 1
  while i < deg:
    ret = (ret + self.pre(i shl 1) * ret.inv(i shl 1)) * inv2
    i = i shl 1

  return ret.pre(deg)

proc expRec[T](self: FormalPowerSeries[T]):auto =
  doAssert self[0] == 0
  let n = self.len
  var m = 1
  while m < n: m *= 2
  var conv_coeff = initFormalPowerSeries[T](m)
  for i in 1..<n: conv_coeff[i] = self[i] * i
  return self.onlineConvolutionExp(conv_coeff).pre(n)

# F(0) must be 0
proc exp[T](self: FormalPowerSeries[T], deg = -1):auto =
  doAssert self[0] == 0
  let n = self.len
  var deg = deg
  if deg == -1: deg = n
  if self.isSetFFT:
    var ret = self
    ret.setlen(deg)
    return ret.expRec()
  var ret = initFormalPowerSeries[T](@[T(1)])
  var i = 1
  while i < deg:
    ret = (ret * (self.pre(i shl 1) + T(1) - ret.log(i shl 1))).pre(i shl 1);
    i = i shl 1
  return ret.pre(deg)

proc onlineConvolutionExp[T](self: FormalPowerSeries[T], conv_coeff:FormalPowerSeries[T]):auto =
  let n = conv_coeff.len
  doAssert((n and (n - 1)) == 0)
  var conv_ntt_coeff = newSeq[FormalPowerSeries[T]]()
  var i = n
  let (is_set, fft, ifft) = self.getFFT()
  doAssert(is_set)
  while (i shr 1) > 0:
    var g = conv_coeff.pre(i)
    fft(g)
    conv_ntt_coeff.add(g)
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
      fft(pre)
      for i in 0..<r - l: pre[i] *= conv_ntt_coeff[d][i]
      ifft(pre)
      for i in 0..<r - m: conv_ret[m + i] += pre[m + i - l]
      rec(m, r, d + 1)
  rec(0, n, 0)
  return conv_arg

proc pow[T](self: FormalPowerSeries[T], k:int, deg = -1):auto =
  let n = self.len
  var deg = deg
  if deg == -1: deg = n
  for i in 0..<n:
    if self[i] != T(0):
      let rev = T(1) / self[i]
      var ret = (((self * rev) shr i).log() * T(k)).exp() * (self[i]^k)
      if i * k > deg: return initFormalPowerSeries[T](deg)
      ret = (ret shl (i * k)).pre(deg)
      if ret.len < deg:
        ret.setlen(deg)
      return ret
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

# operators +, -, *, div, mod {{{
proc `+`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result += r
proc `+`[T](self:FormalPowerSeries[T];v:T):FormalPowerSeries[T] = result = self;result += v
proc `-`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result -= r
proc `-`[T](self:FormalPowerSeries[T];v:T):FormalPowerSeries[T] = result = self;result -= v
proc `*`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result *= r
proc `*`[T](self:FormalPowerSeries[T];v:T):FormalPowerSeries[T] = result = self;result *= v
proc `div`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`div=` (r)
proc `mod`[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`mod=` (r)
# }}}
# }}}

proc Frac(n, m:SomeIntC):Mint = Mint(n) / Mint(m)

var amc = initArbitraryModConvolution[Mint, FastFourierTransformLongDouble]()

# coef_of_generating_function {{{
proc coef_of_generating_function(P,Q:FormalPowerSeries[FieldElem],N:int):auto =
  let mult = P.getMult()
  assert Q[0] == 1 and Q.len == P.len + 1
  var (P, Q, N) = (P, Q, N)
  while N > 0:
    var Q1 = Q
    for i in countup(0, Q.len - 1, 2): Q1[i] = Q[i]
    for i in countup(1, Q.len - 1, 2): Q1[i] = -Q[i]
    block:
      var PQ1 = mult(P, Q1)
      P.setLen(0)
      for i in countup(N mod 2, PQ1.len - 1, 2): P.add(PQ1[i])
      var QQ1 = mult(Q, Q1)
      Q.setLen(0)
      for i in countup(0, QQ1.len - 1, 2): Q.add(QQ1[i])
    N = N div 2
  return P[0]
# }}}

proc calc(M:int):Mint =
  if M <= 4: return 0
  let N = M - 5
  ans := Mint(0)
  for i in 0..15:
    var d = Frac(((i + 4) * (i + 3) * (i + 2) * (i + 1)) div 24, 1 shl (i + 5)) * Mint.Comb(-16 + i, N)
    if N mod 2 == 1: d *= -1
    ans += d
  ans0 := Mint(0)
  ans0 += Frac(1, 65536) * Mint.Comb(-5, N)
  ans0 += Frac(1, 8192) * Mint.Comb(-4, N)
  ans0 += Frac(17, 32768) * Mint.Comb(-3, N)
  ans0 += Frac(51, 32768) * Mint.Comb(-2, N)
  ans0 += Frac(969, 262144) * Mint.Comb(-1, N)
  ans += ans0
  return ans


proc main() =
  let
    A = initFormalPowerSeries[Mint]([1, 1]) # 1 + x
    B = initFormalPowerSeries[Mint]([1, -1]) # 1 - x
  var P, Q = @[Mint(1)]
  P.setMult(amc)
  for i in 0..<5: Q = amc.multiply(Q, A)
  for i in 0..<16: Q = amc.multiply(Q, B)
  P.setLen(Q.len - 1)

  let T = nextInt()
  for _ in 0..<T:
    let M = nextInt()
    if M < 5:
      print 0
    else:
      print coef_of_generating_function(P, Q, M - 5)
  return

main()
