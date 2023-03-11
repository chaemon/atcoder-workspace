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

# newSeqWith {{{
from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var H:int
var W:int
var N:int
var r:seq[int]
var c:seq[int]

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

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

#{{{ combination
import sequtils

type Combination[T] = object
  sz:int
  fact_a, rfact_a, inv_a:seq[T]

proc resize[T](self: var Combination[T], sz:int) =
  if sz < self.sz: return
  var sz = max(self.sz * 2, sz)
  self.fact_a.setlen(sz + 1)
  self.rfact_a.setlen(sz + 1)
  self.inv_a.setlen(sz + 1)
  for i in self.sz + 1..sz: self.fact_a[i] = self.fact_a[i-1] * i
  self.rfact_a[sz] = getDefault(T).init(1) / self.fact_a[sz]
  for i in countdown(sz - 1, self.sz + 1): self.rfact_a[i] = self.rfact_a[i + 1] * (i + 1)
  for i in self.sz + 1..sz: self.inv_a[i] = self.rfact_a[i] * self.fact_a[i - 1]
  self.sz = sz

proc initCombination[T](sz = 100):Combination[T] = 
  let one = getDefault(T).init(1)
  result = Combination[T](sz:0, fact_a: @[one], rfact_a: @[one], inv_a: @[one])
  result.resize(sz)

proc fact[T](self:var Combination[T], k:int):T =
  self.resize(k)
  return self.fact_a[k]
proc rfact[T](self:var Combination[T], k:int):T =
  self.resize(k)
  self.rfact_a[k]
proc inv[T](self:var Combination[T], k:int):T =
  self.resize(k)
  self.inv_a[k]

proc P[T](self:var Combination[T], n,r:int):T =
  if r < 0 or n < r: return T()
  return self.fact(n) * self.rfact(n - r)

proc C[T](self:var Combination[T], p,q:int):T =
  if q < 0 or p < q: return T()
  return self.fact(p) * self.rfact(q) * self.rfact(p - q)

#}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)

proc solve() =
  var cmb = initCombination[Mint]()
  var p = newSeq[(int,int)]()
  for i in 0..<N: p.add((r[i], c[i]))
  p.add((H - 1, W - 1))
  var dp = newSeqWith(p.len, 2, initMint(0))
  p.sort()
  for i in 0..<p.len:
    let (x, y) = (p[i][0], p[i][1])
    dp[i][1] += cmb.C(x + y, x)
    for j in 0..<i:
      let (x2, y2) = (p[j][0], p[j][1])
      if y2 > y: continue
      for d in 0..<2:
        dp[i][(d + 1) mod 2] += dp[j][d] * cmb.C(x - x2 + y - y2, x - x2)
  echo dp[^1][1] - dp[^1][0]
  return

#{{{ input part
block:
  H = nextInt()
  W = nextInt()
  N = nextInt()
  r = newSeqWith(N, 0)
  c = newSeqWith(N, 0)
  for i in 0..<N:
    r[i] = nextInt() - 1
    c[i] = nextInt() - 1
  solve()
#}}}
