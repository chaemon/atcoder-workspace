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

const MOD = 1000000007
var N:int
var K:int
var a:seq[seq[int]]

# Matrix {{{
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

import sequtils

type Matrix[T] = seq[seq[T]]
type Vector[T] = seq[T]

proc initMatrix[T](self: Matrix[T]):Matrix[T] = return self
proc initMatrix[T](n:int, m: int):Matrix[T] = Matrix[T](newSeqWith(n, newSeqWith(m, getDefault(T))))
proc initMatrix[T](n:int):Matrix[T] = Matrix[T](newSeqWith(n, newSeqWith(n, getDefault(T))))

proc initVector[T](n:int):Vector[T] = Vector[T](newSeqWith(n, getDefault(T)))

proc height[T](self: Matrix[T]):int = self.len
proc width[T](self: Matrix[T]):int = self[0].len

proc Identity[T](n:int):Matrix[T] =
  result = initMatrix[T](n)
  for i in 0..<n: result[i][i] = getDefault(T).init(1)
proc Identity[T](self: Matrix[T]):Matrix[T] =
  result = initMatrix[T](self.len)
  for i in 0..<self.len: result[i][i] = getDefault(T).init(1)

proc `+=`[T](self: var Matrix[T], B: Matrix[T]) =
  let (n, m) = (self.height, self.width)
  assert(n == B.height() and m == B.width())
  for i in 0..<n:
    for j in 0..<m:
      self[i][j] += B[i][j]

proc `-=`[T](self: var Matrix[T], B: Matrix[T]) =
  let (n, m) = (self.height, self.width)
  assert(n == B.height() and m == B.width())
  for i in 0..<n:
    for j in 0..<m:
      self[i][j] -= B[i][j]

proc `*=`[T](self: var Matrix[T], B: Matrix[T]) =
  let (n,m,p) = (self.height, B.width, self.width)
  assert(p == B.height())
  var C = initMatrix[T](n, m)
  for i in 0..<n:
    for j in 0..<m:
      for k in 0..<p:
        C[i][j] += self[i][k] * B[k][j]
  swap(self, C)
proc `*`[T](self: Matrix[T], v: Vector[T]): Vector[T] =
  let (n,m) = (self.height, self.width)
  result = initVector[T](n)
  assert(v.len == m)
  var C = initMatrix[T](n, m)
  for i in 0..<n:
    for j in 0..<m:
        result[i] += self[i][j] * v[j]

proc `+`[T](self: Matrix[T], B:Matrix[T]):Matrix[T] =
  result = self; result += B
proc `-`[T](self: Matrix[T], B:Matrix[T]):Matrix[T] =
  result = self; result -= B
proc `*`[T](self: Matrix[T], B:Matrix[T]):Matrix[T] =
  result = self; result *= B

proc `$`[T](self: Matrix[T]):string =
  result = ""
  let (n,m) = (self.height, self.width)
  for i in 0..<n:
    result &= "["
    for j in 0..<m:
      result &= $(self[i][j])
      result &= (if j + 1 == m: "]\n" else: ",")

proc determinant[T](self: Matrix[T]):T =
  var B = initMatrix(self)
  assert(self.width() == self.height());
  result = getDefault(T).init(1)
  for i in 0..<self.width():
    var idx = -1
    for j in i..<self.width():
      if B[j][i] != getDefault(T).init(0): idx = j
    if idx == -1: return getDefault(T).init(0)
    if i != idx:
      result *= getDefault(T).init(-1)
      swap(B[i], B[idx])
    result *= B[i][i];
    let vv = B[i][i]
    for j in 0..<self.width():
      B[i][j] /= vv
    for j in i+1..<self.width():
      let a = B[j][i]
      for k in 0..<self.width():
        B[j][k] -= B[i][k] * a;
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

#{{{ ModInt[Mod]
#proc getDefault(T:typedesc): T = (var temp:T;temp)
#proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v *= initModInt(a, Mod).v
  self.v = self.v mod MOD
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

proc solve() =
  var A = initMatrix[Mint](N)
  for i in 0..<N:
    for j in 0..<N:
      A[j][i] = initMint(a[i][j])
  var b = initVector[Mint](N)
  for i in 0..<N: b[i] = initMint(1)
  b = A^K * b
  echo b.sum
  return

#{{{ input part
block:
  N = nextInt()
  K = nextInt()
  a = newSeqWith(N, newSeqWith(N, nextInt()))
  solve()
#}}}
