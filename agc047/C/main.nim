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

const Mod = 200003

var N:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

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

#type Real = float
type Real = clongdouble

type Complex = tuple[x, y:Real]

proc initComplex[S,T](x:S, y:T):Complex = (Real(x), Real(y))

proc `+`(a,b:Complex):Complex = initComplex(a.x + b.x, a.y + b.y)
proc `-`(a,b:Complex):Complex = initComplex(a.x - b.x, a.y - b.y)
proc `*`(a,b:Complex):Complex = initComplex(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
proc conj(a:Complex):Complex = initComplex(a.x, -a.y)

type SeqComplex = object
  real, imag: seq[Real]

proc initSeqComplex(n:int):SeqComplex = SeqComplex(real: newSeqWith(n, Real(0)), imag: newSeqWith(n, Real(0)))

proc setLen(self: var SeqComplex, n:int) =
  self.real.setLen(n)
  self.imag.setLen(n)
proc swap(self: var SeqComplex, i, j:int) =
  swap(self.real[i], self.real[j])
  swap(self.imag[i], self.imag[j])

type FastFourierTransform = object of RootObj
  base:int
  rts: SeqComplex
  rev:seq[int]

proc getC(self: SeqComplex, i:int):Complex = (self.real[i], self.imag[i])
proc `[]`(self: SeqComplex, i:int):Complex = self.getC(i)
proc `[]=`(self: var SeqComplex, i:int, x:Complex) =
  self.real[i] = x.x
  self.imag[i] = x.y

proc initFastFourierTransform():FastFourierTransform = 
  return FastFourierTransform(base:1, rts: SeqComplex(real: @[Real(0), Real(1)], imag: @[Real(0), Real(0)]), rev: @[0, 1])
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
      self.rts[(i shl 1) + 1] = initComplex(cos(angle_i), sin(angle_i))
    self.base.inc

proc fft(self:var FastFourierTransform; a:var SeqComplex, n:int) =
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

proc ifft(self: var FastFourierTransform; a: var SeqComplex, n:int) =
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
  var fa = initSeqComplex(sz)
  for i in 0..<sz:
    let x = if i < a.len: a[i] else: 0
    let y = if i < b.len: b[i] else: 0
    fa[i] = initComplex(x, y)
  self.fft(fa, sz)
  let
    r = initComplex(0, - Real(1) / (Real((sz shr 1) * 4)))
    s = initComplex(0, 1)
    t = initComplex(Real(1)/Real(2), 0)
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

proc main() =
  var
    r = 2
    e = newSeqWith(Mod, -1)
  var prod = 1
  for i in 0..<Mod-1:
    assert e[prod] == -1
    e[prod] = i
    prod *= r
    prod = prod mod Mod
  var v = newSeq[int](Mod - 1)
  for a in A:
    if a == 0: continue
    v[e[a]].inc
  v = fft_t.multiply(v, v)
  prod = 1
  var
    ans = 0
  for i,a in v:
    ans += prod * a
    prod *= r
    prod = prod mod Mod
  for a in A:
    ans -= a * a mod Mod
  ans = ans div 2
  print ans
  return

main()

