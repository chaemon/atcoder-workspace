#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
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
#}}}

var A:int
var B:int
var M:int


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

import strformat

macro declareModInt(Mod:static[int], t: untyped):untyped =
  var strBody = ""
  strBody &= fmt"""
type {t.repr} = ModInt[{Mod.repr}]
proc init{t.repr}(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
proc `$`(a:{t.repr}):string = $(a.v)
converter to{t.repr}(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
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
  x.v is int32
  x.getMod()
#  x.getMod() is int32
  when T isnot ModInt: setMod(T, int)
type SomeIntC = concept x
  x is SomeInteger or x is ModIntC
 
proc Identity(self:ModInt or DMint):auto = result = self;result.v = 1
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
proc inv(self: ModIntC):auto =
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
proc `/=`(a:var ModIntC,b:SomeIntC) = a *= a.init(b).inv()
proc `+`(a:ModIntC,b:SomeIntC):auto = result = a;result += b
proc `-`(a:ModIntC,b:SomeIntC):auto = result = a;result -= b
proc `*`(a:ModIntC,b:SomeIntC):auto = result = a;result *= b
proc `/`(a:ModIntC,b:SomeIntC):auto = result = a;result /= b
proc `^`(a:ModIntC,b:SomeInteger):auto = result = a;result ^= b
# }}}
# }}}

#{{{ pow[T]: Identity and *= must be defined
#proc Identity(self: seq[int]): seq[int] =
#  return lc[i | (i <- 0..<self.len), int]

proc `^=`[T](self: var T, k:int) =
  var k = k
  var B = self.Identity()
  while k > 0:
    if (k and 1) > 0: B *= self
    self *= self;k = k shr 1
  self.swap(B)

proc `^`[T](self: T, k:int):T =
  result = self;result ^= k
#}}}

# Matrix {{{
import sequtils

type Matrix[T] = seq[seq[T]]
type Vector[T] = seq[T]

proc height[T](self: Matrix[T]):int = self.len
proc width[T](self: Matrix[T]):int = self[0].len

#template initMatrix[T](self: Matrix[T]):Matrix[T] = return self
template initMatrix[T](n, m:int):Matrix[T] = newSeqWith(n, newSeqWith(m, T.default))
template initMatrix[T](self: Matrix[T], n, m:int):Matrix[T] = newSeqWith(n, newSeqWith(m, T.default))
template initMatrix[T](n:int):Matrix[T] = newSeqWith(n, newSeqWith(n, T.default))

type RingElem = concept x, type T
  x + x
  x - x
  x * x
  T(1)
  T(0)
type FieldElem = concept x, type T
  x is RingElem
  x / x

type XC = concept x
  true
type DoubleSeqC = concept x
  x[0][0] is SomeNumber

template initMatrix[T](a:DoubleSeqC):Matrix[T] =
  when a is seq[seq[T]]:
    a
  else:
    var A = initMatrix[T](a.len, a[0].len)
    for i in 0..<A.height:
      for j in 0..<A.width:
        A[i][j] = T(a[i][j])
    A

template initVector[T](n:int):Vector[T] = Vector[T](newSeqWith(n, T.default))
template initVector[T](a:openArray[XC]):Vector[T] =
  when a is seq[T]:
    a
  else:
    var v = initVector[T](a.len)
    for i in 0..<v.len: v[i] = T(a[i])
    v

proc IdentityMatrix[T](n:int):Matrix[T] =
  result = initMatrix[T](n)
  for i in 0..<n: result[i][i] = T(1)
proc Identity[T](self: Matrix[T]):Matrix[T] = IdentityMatrix[T](self.height)

import sugar

proc getIsZeroImpl[T](self:Matrix[T], update = false, f:proc(a:T):bool = nil):proc(a:T):bool =
  var isZero{.global.}:(a:T)->bool  = (a:T) => a == T(0)
  if update:isZero = f
  return isZero
proc getIsZero[T](self:Matrix[T]):auto = self.getIsZeroImpl(false, nil)
proc setIsZero[T](self:Matrix[T], isZero:proc(a:T):bool) = self.getIsZeroImpl(true, isZero)

proc `+=`(self: var Matrix[RingElem], B: Matrix[RingElem]) =
  let (n, m) = (self.height, self.width)
  assert(n == B.height() and m == B.width())
  for i in 0..<n:
    for j in 0..<m:
      self[i][j] += B[i][j]

proc `-=`(self: var Matrix[RingElem], B: Matrix[RingElem]) =
  let (n, m) = (self.height, self.width)
  assert(n == B.height() and m == B.width())
  for i in 0..<n:
    for j in 0..<m:
      self[i][j] -= B[i][j]

proc `*=`[T:RingElem](self: var Matrix[T], B: Matrix[T]) =
  let (n,m,p) = (self.height, B.width, self.width)
  assert(p == B.height)
  var C = initMatrix[T](n, m)
  for i in 0..<n:
    for j in 0..<m:
      for k in 0..<p:
        C[i][j] += self[i][k] * B[k][j]
  swap(self, C)
proc `*`[T:RingElem](self: Matrix[T], v: Vector[T]): Vector[T] =
  let (n,m) = (self.height, self.width)
  result = initVector[T](n)
  assert(v.len == m)
  for i in 0..<n:
    for j in 0..<m:
        result[i] += self[i][j] * v[j]

proc `+`(self: Matrix[RingElem], B:Matrix[RingElem]):auto =
  result = self; result += B
proc `-`(self: Matrix[RingElem], B:Matrix[RingElem]):auto =
  result = self; result -= B
proc `*`[T:RingElem](self: Matrix[T], B:Matrix[T]):Matrix[T] =
  result = self; result *= B

proc `$`(self: Matrix[RingElem]):string =
  result = ""
  let (n,m) = (self.height, self.width)
  for i in 0..<n:
    result &= "["
    for j in 0..<m:
      result &= $(self[i][j])
      result &= (if j + 1 == m: "]\n" else: ",")

proc determinant[T:FieldElem](self: Matrix[T]):auto =
  var B = self
  assert(self.width() == self.height())
  result = T(1)
  for i in 0..<self.width():
    var idx = -1
    for j in i..<self.width():
      if not (self.getIsZero())(B[j][i]):
        idx = j;break
    if idx == -1: return T(0)
    if i != idx:
      result *= T(-1)
      swap(B[i], B[idx])
    result *= B[i][i]
    let vv = B[i][i]
    for j in 0..<self.width():
      B[i][j] /= vv
    for j in i+1..<self.width():
      let a = B[j][i]
      for k in 0..<self.width():
        B[j][k] -= B[i][k] * a
# }}}


proc solve() =
  DMint.setMod(M)
  let g = gcd(A, B)
  var ans = DMint(1)
  block:
    let a = DMint(10)
    var M = initMatrix[DMint](2, 2)
    M[0][0] = 1;M[0][1] = 1
    M[1][1] = a
    var b = initVector[DMint](2)
    b[1] = 1
    b = M^A * b
    ans *= b[0]
  block:
    let a = DMint(10)^g
    let B = B div g
    var M = initMatrix[DMint](2, 2)
    M[0][0] = 1;M[0][1] = 1
    M[1][1] = a
    var b = initVector[DMint](2)
    b[1] = 1
    b = M^B * b
    ans *= b[0]
  echo ans
  return

#{{{ input part
block:
  A = nextInt()
  B = nextInt()
  M = nextInt()
  solve()
#}}}
