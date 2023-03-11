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
var A:seq[int]
var B:seq[int]

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

const K = 2000
var a: array[-K..K, array[-K..K, Mint]]
var ct: array[1..K, array[1..K, int]]

proc solve() =
  var ans = initMint(0)
  for i in 0..<N: ct[A[i]][B[i]].inc
  for x in -K..K:
    for y in -K..K:
      a[x][y] = initMint(0)
      if x > -K:
        a[x][y] += a[x - 1][y]
      if y > -K:
        a[x][y] += a[x][y - 1]
      if x > 0 and y > 0:
        ans += a[x][y] * ct[x][y]
      if x < 0 and y < 0:
        a[x][y] += initMint(ct[-x][-y])
  for i in 0..<N:
    ans -= Mint.C(A[i] * 2 + B[i] * 2, A[i] * 2)
  echo ans / 2
  return

#{{{ input part
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve()
#}}}
