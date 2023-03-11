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
var K:int
var N:int

# input part {{{
proc main()
block:
  K = nextInt()
  N = nextInt()
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

#{{{ FastFourierTransformclongdouble
# clongdouble {{{

proc initclongdouble(a:SomeNumber):clongdouble {.importcpp: "(long double)(#)", nodecl.}
converter toclongdouble(a:SomeNumber):clongdouble = initclongdouble(a)

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

type Real = clongdouble

type C = tuple[x, y:Real]

proc initC[S,T](x:S, y:T):C = (x.Real, y.Real)

proc `+`(a,b:C):C = initC(a.x + b.x, a.y + b.y)
proc `-`(a,b:C):C = initC(a.x - b.x, a.y - b.y)
proc `*`(a,b:C):C = initC(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
proc conj(a:C):C = initC(a.x, -a.y)

type SeqC = object
  real, imag: seq[clongdouble]
type FFTType = SeqC

proc initSeqC(n:int):SeqC = SeqC(real: newSeqWith(n, clongdouble(0)), imag: newSeqWith(n, clongdouble(0)))

proc setLen(self: var SeqC, n:int) =
  self.real.setLen(n)
  self.imag.setLen(n)
proc swap(self: var SeqC, i, j:int) =
  swap(self.real[i], self.real[j])
  swap(self.imag[i], self.imag[j])

type FastFourierTransformclongdouble = object of RootObj
  base:int
  rts: SeqC
  rev:seq[int]

proc getC(self: SeqC, i:int):C = (self.real[i], self.imag[i])
proc `[]`(self: SeqC, i:int):C = self.getC(i)
proc `[]=`(self: var SeqC, i:int, x:C) =
  self.real[i] = x.x
  self.imag[i] = x.y

proc dot(a: FFTType, b:FFTType):FFTType =
  result = a
  for i in 0..<a.real.len: result[i] = a[i] * b[i]

proc initFastFourierTransformclongdouble():FastFourierTransformclongdouble = 
  return FastFourierTransformclongdouble(base:1, rts: SeqC(real: @[clongdouble(0), clongdouble(1)], imag: @[clongdouble(0), clongdouble(0)]), rev: @[0, 1])
proc init(self:typedesc[FastFourierTransformclongdouble]):auto = initFastFourierTransformclongdouble()

proc ensureBase(self:var FastFourierTransformclongdouble; nbase:int) =
  if nbase <= self.base: return
  let L = 1 shl nbase
  self.rev.setlen(1 shl nbase)
  self.rts.setlen(1 shl nbase)
  for i in 0..<(1 shl nbase): self.rev[i] = (self.rev[i shr 1] shr 1) + ((i and 1) shl (nbase - 1))
  while self.base < nbase:
#    let angle = initclongdouble(PI) * initclongdouble(2) / initclongdouble(1 shl (self.base + 1))
    let angle = acos(initclongdouble(-1)) * initclongdouble(2) / initclongdouble(1 shl (self.base + 1))
    for i in (1 shl (self.base - 1))..<(1 shl self.base):
      self.rts[i shl 1] = self.rts[i]
      let angle_i = angle * initclongdouble(2 * i + 1 - (1 shl self.base))
      self.rts[(i shl 1) + 1] = initC(cos(angle_i), sin(angle_i))
    self.base.inc

proc fft(self:var FastFourierTransformclongdouble; a:var SeqC, n:int) =
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

proc ifft(self: var FastFourierTransformclongdouble; a: var SeqC, n:int) =
  for i in 0..<n: a[i] = a[i].conj()
  let rN = clongdouble(1) / clongdouble(n)
  self.fft(a, n)
  for i in 0..<n:
    let t = a[i]
    a[i] = (t.x * rN, t.y * rN)

proc multiply(self:var FastFourierTransformclongdouble; a,b:seq[int]):seq[int] =
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
#}}}

#{{{ ArbitraryModConvolution
type ArbitraryModConvolution[ModInt] = object
  fft_t:FastFourierTransformclongdouble

#proc llround(n: float): int{.importc: "llround", nodecl.}
proc init[ModInt](t:typedesc[ArbitraryModConvolution[ModInt]]):auto =
  ArbitraryModConvolution[ModInt](fft_t:FastFourierTransformclongdouble.init())

proc multiply[ModInt](self:var ArbitraryModConvolution[ModInt], a,b:seq[ModInt], need = -1):seq[ModInt] =
  var need = need
  if need == -1: need = a.len + b.len - 1
  var nbase = 0
  while (1 shl nbase) < need: nbase.inc
  self.fft_t.ensureBase(nbase)
  let sz = 1 shl nbase
  var fa = initSeqC(sz)
  for i in 0..<a.len: fa[i] = initC(a[i].v and ((1 shl 15) - 1), a[i].v shr 15)
  self.fft_t.fft(fa, sz)
  var fb = initSeqC(sz)
  if a == b:
    fb = fa
  else:
    for i in 0..<b.len:
      fb[i] = initC(b[i].v and ((1 shl 15) - 1), b[i].v shr 15)
    self.fft_t.fft(fb, sz)
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
  self.fft_t.fft(fa, sz)
  self.fft_t.fft(fb, sz)
  result = newSeq[ModInt](need)
  for i in 0..<need:
    var
      aa = llround(fa[i].x)
      bb = llround(fb[i].x)
      cc = llround(fa[i].y)
    aa = ModInt(aa).v; bb = ModInt(bb).v; cc = ModInt(cc).v
    result[i] = ModInt(aa + (bb shl 15) + (cc shl 30))

proc fft[ModInt](self: var ArbitraryModConvolution[ModInt], a:seq[ModInt]):SeqC =
  result = initSeqC(a.len)
  for i in 0..<a.len: result.real[i] = a[i].v
  self.fft_t.fft(result, a.len)
proc ifft[ModInt](self: var ArbitraryModConvolution[ModInt], a:SeqC):seq[ModInt] =
  let n = a.real.len
  var a = a
  self.fft_t.ifft(a, n)
  result = newSeq[ModInt](n)
  for i in 0..<result.len: result[i] = ModInt(llround(a.real[i]))
proc fftType[ModInt](self: typedesc[ArbitraryModConvolution[ModInt]]):auto = typedesc[SeqC]
#}}}

type BaseFFT[T] = ArbitraryModConvolution[T]

# FormalPowerSeries {{{
type FieldElem = concept x, type T
  x + x
  x - x
  x * x
  x / x

import sugar, sequtils, strformat

type FormalPowerSeries[T:FieldElem] = seq[T]

proc initFormalPowerSeries[T:FieldElem](n:int):auto = FormalPowerSeries[T](newSeq[T](n))

template initFormalPowerSeries[T, S](data: openArray[S]):auto =
  when S is T: data
  else: data.mapIt(T(it))
proc `$`[T](self:FormalPowerSeries[T]):string = return self.mapIt($it).join(" ")

macro revise(a, b) =
  parseStmt(fmt"""let {a.repr} = if {a.repr} == -1: {b.repr} else: {a.repr}""")


#{{{ set mult, fft, sqrt
type
  SQRT[T] = proc(t:T):T

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

proc `*=`[T](self: var FormalPowerSeries[T], v:T) =
  for t in self.mitems: t *= v

proc `*=`[T](self: var FormalPowerSeries[T],  r: FormalPowerSeries[T]) =
  if self.len == 0 or r.len == 0:
    self.setlen(0)
  else:
    when declared(BaseFFT):
      var fft = BaseFFT[T].init()
      self = fft.multiply(self, r)
    else:
      var c = initFormalPowerSeries[T](self.len + r.len - 1)
      for i in 0..<self.len:
        for j in 0..<r.len:
          c[i + j] += self[i] + r[j]
      self.swap(c)

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
  when declared(BaseFFT):
    proc invFast[T](self: FormalPowerSeries[T]):auto =
      doAssert(self[0] != 0)
      let n = self.len
    
      var res = initFormalPowerSeries[T](1)
      res[0] = T(1) / self[0]
      var fft = BaseFFT[T].init()
      var d = 1
      while d < n:
        var f, g = initFormalPowerSeries[T](2 * d)
        for j in 0..<min(n, 2 * d): f[j] = self[j]
        for j in 0..<d: g[j] = res[j]
        var f1 = fft.fft(f)
        var g1 = fft.fft(g)
        f1 = dot(f1, g1)
        f = fft.ifft(f1)
        for j in 0..<d:
          f[j] = T(0)
          f[j + d] = -f[j + d]
        f1 = fft.fft(f)
        f1 = dot(f1, g1)
        f = fft.ifft(f1)
        for j in 0..<d: f[j] = res[j]
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
        if (i and 1) > 0: return initFormalPowerSeries[T](0)
        if deg - i div 2 <= 0: break
        result = (self shr i).sqrt(deg - i div 2)
        if result.len == 0: return initFormalPowerSeries[T](0)
        result = result shl (i div 2)
        if result.len < deg: result.setlen(deg)
        return
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

# F(0) must be 0
proc exp[T](self: FormalPowerSeries[T], deg = -1):auto =
  doAssert self[0] == 0
  deg.revise(self.len)
  when declared(BaseFFT):
    var fft = BaseFFT[T].init()
    proc onlineConvolutionExp[T](self: FormalPowerSeries[T], conv_coeff:FormalPowerSeries[T]):auto =
      let n = conv_coeff.len
      doAssert((n and (n - 1)) == 0)
      var conv_ntt_coeff = newSeq[FFTType]()
      var i = n
      while (i shr 1) > 0:
        var g = conv_coeff.pre(i)
        var g1 = fft.fft(g)
        conv_ntt_coeff.add(g1)
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
          var pre1 = fft.fft(pre)
          pre1 = dot(pre1, conv_ntt_coeff[d])
          pre = fft.ifft(pre1)
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
    var ret = initFormalPowerSeries[T](@[T(1)])
    var i = 1
    while i < deg:
      ret = (ret * (self.pre(i shl 1) + T(1) - ret.log(i shl 1))).pre(i shl 1);
      i = i shl 1
    return ret.pre(deg)

proc pow[T](self: FormalPowerSeries[T], k:int, deg = -1):auto =
  let n = self.len
  deg.revise(n)
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

# coef_of_generating_function {{{
proc coef_of_generating_function(P,Q:FormalPowerSeries[FieldElem],N:int):auto =
  assert Q[0] == 1 and Q.len == P.len + 1
  var (P, Q, N) = (P, Q, N)
  while N > 0:
    var Q1 = Q
    for i in countup(0, Q.len - 1, 2): Q1[i] = Q[i]
    for i in countup(1, Q.len - 1, 2): Q1[i] = -Q[i]
    block:
      var PQ1 = P * Q1
      P.setLen(0)
      for i in countup(N mod 2, PQ1.len - 1, 2): P.add(PQ1[i])
      var QQ1 = Q * Q1
      Q.setLen(0)
      for i in countup(0, QQ1.len - 1, 2): Q.add(QQ1[i])
    N = N div 2
  return P[0]
# }}}

proc main() =
  N.dec
  var f = initFormalPowerSeries[Mint](K)
  for i in 0..<K:f[i] = Mint(1)
  var g = initFormalPowerSeries[Mint](K + 1)
  g[0] = Mint(1)
  for i in 1..K:g[i] = Mint(-1)
  var h = f * g
  h.setLen(g.len - 1)
  echo coef_of_generating_function(h, g, N)
  return

main()

